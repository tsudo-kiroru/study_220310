import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/riverpod/auth_store.dart';
import 'package:riverpod_sample/riverpod/post_store.dart';
import 'package:riverpod_sample/models/profile_model.dart';
import 'package:riverpod_sample/repositories/profile_repository.dart';

final profileStore = ChangeNotifierProvider((ref) => ProfileNotifier(ref));

class ProfileNotifier extends ChangeNotifier {
  final Ref ref;
  ProfileModel? profile;

  ProfileNotifier(this.ref) : super() {
    ref.listen(authStore, (previous, next) async {
      final authorized = next as bool?;
      if (authorized == null) { return; }
      // ログアウトしたらプロフィールをクリア
      if (!authorized) {
        profile = null;
        notifyListeners();
      }
    });

    ref.listen(myPostStore, (previous, next) { 
      if (profile == null) { return; }
      final posts = next as List<String>?;
      if (posts == null) { return; }
      profile = ProfileModel(name: profile!.name, totalPost: posts.length);
      notifyListeners();
    });
  }

  String get introduction {
    if (profile == null) { return "プロフィール"; }
    return "${profile?.name} - 投稿数: ${profile?.totalPost}";
  }

  Future<ProfileModel?> fetch() async {
    profile = await ProfileRepository().fetch();
    notifyListeners();
    return profile!;
  }
}
