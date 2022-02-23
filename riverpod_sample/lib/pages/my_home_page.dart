import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/components/list_cell.dart';
import 'package:riverpod_sample/viewmodel/auth_viewmodel.dart';
import 'package:riverpod_sample/viewmodel/profile_viewmodel.dart';
import 'package:riverpod_sample/viewmodel/post_viewmodel.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authViewModelProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);
    final profile = ref.watch(profileViewModelProvider.select((value) => value.profile));
    print(profile);
    final profileViewModel = ref.read(profileViewModelProvider);
    final myPosts = ref.watch(myPostViewModelProvider);
    final myPostsViewModel = ref.read(myPostViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("title"),
      ),
      body: Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(profileViewModel.introduction),
            ListCell(
              title: myPosts.isEmpty ? '投稿なし' : myPosts.last,
              buttonTitle: auth ? '投稿を増やす' : '会員だけが投稿できます',
              handler: () {
                if (!auth) return;
                myPostsViewModel.add("投稿:No${myPosts.length + 1}");
              }
            ),
            ListCell(
              title: auth ? '認証済み' : '未認証',
              buttonTitle: auth ? 'ログアウト' : 'ログイン',
              handler: () async {
                if (!auth) {
                  await authViewModel.login();
                  // ログイン後にプロフィールと投稿を取得（並列実行）
                  await Future.wait([
                    profileViewModel.fetch(),
                    myPostsViewModel.fetch(),
                  ]);
                } else {
                  await authViewModel.logout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
