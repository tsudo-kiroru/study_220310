import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/components/list_cell.dart';
import 'package:riverpod_sample/state/auth_state.dart';
import 'package:riverpod_sample/state/post_state.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final auth = ref.watch(authStateProvider);
    final myPost = ref.watch(myPostStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListCell(
              title: "${myPost.posts.length == 0 ? 'ツイートなし' : myPost.posts.last}",
              buttonTitle: "投稿を増やす",
              handler: () {
                ref.read(myPostStateProvider.notifier).add();
              }
            ),
            ListCell(
              title: "${auth ? '認証済み' : '未認証'}",
              buttonTitle: "認証状態をトグル",
              handler: () {
                ref.read(authStateProvider.notifier).toggle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
