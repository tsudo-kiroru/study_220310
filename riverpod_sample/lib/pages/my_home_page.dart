import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/components/list_cell.dart';
import 'package:riverpod_sample/riverpod/auth_store.dart';
import 'package:riverpod_sample/riverpod/profile_store.dart';
import 'package:riverpod_sample/riverpod/post_store.dart';
import 'package:riverpod_sample/pages/my_home_viewmodel.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = MyHomeViewModel(ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text("title"),
      ),
      body: Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(viewModel.profileIntroduction),
            ListCell(
              title: viewModel.myPosts.isEmpty ? '投稿なし' : viewModel.myPosts.last,
              buttonTitle: viewModel.auth ? '投稿を増やす' : '会員だけが投稿できます',
              handler: () {
                viewModel.addPost();
              }
            ),
            ListCell(
              title: viewModel.auth ? '認証済み' : '未認証',
              buttonTitle: viewModel.auth ? 'ログアウト' : 'ログイン',
              handler: () async {
                if (!viewModel.auth) {
                  viewModel.login();
                } else {
                  viewModel.logout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
