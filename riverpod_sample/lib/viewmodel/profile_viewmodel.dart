import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/viewmodel/auth_viewmodel.dart';
import 'package:riverpod_sample/viewmodel/post_viewmodel.dart';
import 'package:riverpod_sample/models/profile_model.dart';
import 'package:riverpod_sample/repositories/profile_repository.dart';

final profileViewModelProvider = ChangeNotifierProvider((ref) => ProfileViewModel(ref));

class ProfileViewModel extends ChangeNotifier {
  final Ref ref;
  ProfileModel? profile;

  ProfileViewModel(this.ref) : super() {
    ref.listen(authViewModelProvider, (previous, next) async {
      final authorized = next as bool?;
      if (authorized == null) { return; }
      // ログアウトしたらプロフィールをクリア
      if (!authorized) {
        profile = null;
        notifyListeners();
      }
    });

    ref.listen(myPostViewModelProvider, (previous, next) { 
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
