import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/provider/count_store.dart';
import 'package:provider_sample/provider/profile_change_notifier.dart';
import 'package:provider_sample/provider/post_change_notifier.dart';
import 'package:provider_sample/provider/auth_change_notifier.dart';
import '../component/list_cell.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    final profile = context.select((ProfileChangeNotifier store) => store.profile);
    final myPosts = context.select((PostChangeNotifier store) => store.posts);
    final authorized = context.select((AuthChangeNotifier store) => store.authorized);
    /*
     * NOTE: trendPostsはmyPostsと全く同じものを参照します。
     * もし同じ構造を持つ状態を作りたければTrendPostChangeNotifierというクラスを作るしかありません
     */
    // final trendPosts = context.select((PostChangeNotifier store) => store.posts);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListCell(
              title: "${profile.name} - 投稿数: ${profile.totalPost}",
              buttonTitle: "何もしません",
              handler: () {
                print("button tapped");
              }
            ),
            ListCell(
              title: "${myPosts.length == 0 ? 'ツイートなし' : myPosts[myPosts.length - 1]}",
              buttonTitle: "投稿を増やす",
              handler: () {
                context.read<PostChangeNotifier>().add();
              }
            ),
            ListCell(
              title: "${authorized ? '認証済み' : '未認証'}",
              buttonTitle: "認証状態をトグル",
              handler: () {
                context.read<AuthChangeNotifier>().toggle();
              }
            ),
          ],
        ),
      ),
    );
  }
}
