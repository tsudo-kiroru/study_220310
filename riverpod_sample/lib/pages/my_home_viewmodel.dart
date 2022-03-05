import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/riverpod/auth_store.dart';
import 'package:riverpod_sample/riverpod/profile_store.dart';
import 'package:riverpod_sample/riverpod/post_store.dart';
import 'package:riverpod_sample/models/profile_model.dart';

class MyHomeViewModel {
  MyHomeViewModel(this.ref);
  final WidgetRef ref;

  bool get auth => ref.watch(authStore);
  ProfileModel? get profile => ref.watch(profileStore.select((value) => value.profile));
  List<String> get myPosts => ref.watch(myPostStore);

  String get profileIntroduction => ref.read(profileStore).introduction;

  Future<List<String>?> addPost() async {
    if (!auth) return null;
    return ref.read(myPostStore.notifier).add("投稿:No${myPosts.length + 1}");
  }

  Future<void> login() async {
    await ref.read(authStore.notifier).login();
    // ログイン後にプロフィールと投稿を取得（並列実行）
    await Future.wait([
      ref.read(profileStore).fetch(),
      ref.read(myPostStore.notifier).fetch(),
    ]);
  }

  Future<void> logout() async {
    await ref.read(authStore.notifier).logout();
  }
}
