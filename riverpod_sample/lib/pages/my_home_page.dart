import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/components/list_cell.dart';
import 'package:riverpod_sample/state/auth_state.dart';
import 'package:riverpod_sample/state/profile_state.dart';
import 'package:riverpod_sample/state/post_state.dart';
import 'package:riverpod_sample/repositories/auth_repository.dart';
import 'package:riverpod_sample/repositories/profile_repository.dart';
import 'package:riverpod_sample/repositories/post_repository.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final profile = ref.watch(profileStateProvider);
    final myPosts = ref.watch(myPostStateProvider);
    final profileText = profile != null ? "${profile.name} - 投稿数: ${profile.totalPost}" : "プロフィール";

    return Scaffold(
      appBar: AppBar(
        title: const Text("title"),
      ),
      body: Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(profileText),
            ListCell(
              title: myPosts.isEmpty ? 'ツイートなし' : myPosts.last,
              buttonTitle: auth ? '投稿を増やす' : '会員だけが投稿できます',
              handler: () {
                if (!auth) return;
                ref.read(myPostStateProvider.notifier).add("投稿:${myPosts.length + 1}");
              }
            ),
            ListCell(
              title: auth ? '認証済み' : '未認証',
              buttonTitle: auth ? 'ログアウト' : 'ログイン',
              handler: () async {
                if (!auth) {
                  final authorized = await AuthRepository().login();
                  ref.read(authStateProvider.notifier).updateAuthorize(authorized);
                  // ログイン後にプロフィールと投稿を取得
                  final _profile = await ProfileRepository().fetch();
                  if (_profile != null) { ref.read(profileStateProvider.notifier).update(_profile); }
                  final _posts = await PostRepository().fetchPosts();
                  ref.read(myPostStateProvider.notifier).set(_posts);
                } else {
                  await AuthRepository().logout();
                  ref.read(authStateProvider.notifier).updateAuthorize(false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
