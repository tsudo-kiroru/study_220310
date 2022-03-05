import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/components/list_cell.dart';
import 'package:riverpod_sample/riverpod/auth_store.dart';
import 'package:riverpod_sample/riverpod/profile_store.dart';
import 'package:riverpod_sample/riverpod/post_store.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStore);
    final authNotifier = ref.read(authStore.notifier);
    final profile = ref.watch(profileStore.select((value) => value.profile));
    final profileNotifier = ref.read(profileStore);
    final myPosts = ref.watch(myPostStore);
    final myPostsNotifier = ref.read(myPostStore.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("title"),
      ),
      body: Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(profileNotifier.introduction),
            ListCell(
              title: myPosts.isEmpty ? '投稿なし' : myPosts.last,
              buttonTitle: auth ? '投稿を増やす' : '会員だけが投稿できます',
              handler: () {
                if (!auth) return;
                myPostsNotifier.add("投稿:No${myPosts.length + 1}");
              }
            ),
            ListCell(
              title: auth ? '認証済み' : '未認証',
              buttonTitle: auth ? 'ログアウト' : 'ログイン',
              handler: () async {
                if (!auth) {
                  await authNotifier.login();
                  // ログイン後にプロフィールと投稿を取得（並列実行）
                  await Future.wait([
                    profileNotifier.fetch(),
                    myPostsNotifier.fetch(),
                  ]);
                } else {
                  await authNotifier.logout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
