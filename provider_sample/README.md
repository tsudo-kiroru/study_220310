# 状態管理とは
[このQiitaの記事](https://qiita.com/KazaKago/items/1d6477b8d4dc628522e7)の「ケース2」が直感的に状態管理を表しています。  
![alt](/images/master-detail.png)  
＊上記URLより抜粋
このようなMaster-Detailのいいね状態を**とりあえず**整合性を持たせるには

- 親から子に値を渡す
- 子の値の変更をインターフェースで渡す

で**一応**状態を管理することができます。  
<span style="font-size: 200%"><span style="color: #d61b09">「勝ったッ!第3部完!」</span></span>  
ご静聴ありがとうございました。  
...  
...  
...  
...  
...  
とは当然なりません。メルカリのようなWebページを想像してみます。会員としてログインを行なっている状態では閲覧できるページが異なります。Detailに相当する画面への遷移は複数存在します。画面遷移と状態が複雑に絡み合い、インターフェースによる一対一の伝達ではもはや管理しきれないのは明白です。

# Providerとは
Flutterにおける状態管理にはいくつかの定石があります。
- Scoped Model
- Redux
- BLoC/RX
- GetX

その中で現在[Google](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options)が推奨しているのがProviderとRiverpodです。あくまで個人的な印象ですが、この2つは他より直感的で学習コストが低く軽量です。

# Providerのサンプルプロジェクト
（このプロジェクトはUIに全く力を入れません。あくまで状態管理にフォーカスするためです）  
ここでは3つの状態を定義します。ここでは学習のため以下のように簡略化しています。
- プロフィール
    - 名前（ただし認証情報がなければnull）
    - 投稿数
- 認証情報
    - true/false
- 自分の投稿（Twitterのようなイメージ）
    - 投稿の配列（ただし認証情報がなければnull）

ここでいくつか乗り越えなければならない課題について考えます。

1. ある状態が別の状態に依存していて、変化があればそれを反映されたい
2. 別の投稿も状態として保持する場合、構造は自分の投稿の場合と変わらない（OPPでいう再利用）
3. SSOTの原則を守りたい

さて、これらの課題に対してどのように対処したのかソースコードを見てみましょう。

### 1. ある状態の変化が別の状態の変化につながる  
ChangeNotifierProxyProviderを利用して、Widgetツリーの上位で関係性を定義します。  
ただ状態と状態の関係をWidgetツリーで定義するのは果たしてあるべき実装でしょうか？  
「自分の投稿」状態が何に依存するかは「自分の投稿」に関する箇所で記述すべきです。  
また「プロフィール」のように2つ以上の状態に依存する場合はChangeNotifierProxyProvider2を使用するなど拡張性がありません。  
VuexやReduxでは他のstoreを監視できますが、そのような実装をProviderでは実現できません。  
また他の状態に直接アクセスする手段がなく、自身でも他の状態を保持しなくてはならないケースが生まれます。

### 2. 別の投稿も状態として保持する場合、構造は自分の投稿の場合と変わらない
これはProviderの仕組み上不可能です。
```
context.select((T store) => store.{ステート});
```
では何をしているのかというとWidgetツリーからT型であるものを検索するという仕組みを持っています。  
「自分の投稿」と「他人の投稿」の状態を管理するためには`投稿配列`という構造が全く同じでありま別のクラスを作る必要があります。

### 3. SSOTの原則を守りたい
```
runApp(
    MultiProvider(
...
```
とすることでSSOTを確保しています。ただ確実にボイラープレートは増えます。  
DIを行なう仕組みはProviderにはありません。

# Riverpodだと
さて実装上の課題が見えてきましたが、riverpodではこれらの実装はどうなるのでしょうか？時間の関係でコードの一部のみ紹介します。  

### 1. ある状態の変化が別の状態の変化につながる  
StateNorifier内で他の状態を監視することができます。  
```
class ProfileNotifier extends StateNotifier<Profile> {
    final Ref ref;

    ProfileNotifier(this.ref): super(Profile()) {
        // refを通して投稿状態を監視する
        ref.listen(myPostsNotifier, (posts) {
            state.totalPost = posts.length;
        });
    }
}
```
あくまでプロフィールが何に依存しているかをプロフィール内で記述しています。Widgetツリーに依存していません。

### 2. 別の投稿も状態として保持する場合、構造は自分の投稿の場合と変わらない
同じ状態クラスから以下の別のものを定義できます。
```
final myPostsStateProvider = StateNotifierProvider<PostNotifier, [String]>((ref) => PostNotifier(ref));
final trendPostsStateProvider = StateNotifierProvider<PostNotifier, [String]>((ref) => PostNotifier(ref));
```
状態の構造が変わらないのですから、このようにクラスを再利用できるのが自然です。

### 3. SSOTの原則を守りたい
`final`で定義します。形式上はglobal変数と同じ扱いになりますが、importしないとアクセスできないため実用上は問題になりません。  
また逆にimportするだけでそれぞれのWidgetからWidgetRefを介してアクセスできるためDIの機能も果たしています。  
ProviderScopeでラップするため情報源は常に一つとなります。  
（同じ名前やない名前にするとコンパイルエラーとなります、ProviderNotFoundのランタイムエラーが起きるより安全です）

# まとめ
Providerにも課題があり、それをRiverpodでは少なからず解消していることが分かりました。  
TODOとして同じアプリをRiverpodで実装したものと比較すると分かりやすいかもしれません。  
これは次回の勉強会のテーマの1つとしたいと思います。（または引き継ぎ希望w）  
今度こそご静聴ありがとうございました。  
![alt](/images/jojo3ending.jpeg)  
＊「ジョジョの奇妙な冒険 第三部」より抜粋
