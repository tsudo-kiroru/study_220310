import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/state/auth_state.dart';
import 'package:riverpod_sample/state/post_state.dart';
import 'package:riverpod_sample/models/profile_model.dart';

final profileStateProvider = StateNotifierProvider<ProfileStateNotifier, ProfileModel?>((ref) {
  return ProfileStateNotifier(ref);
});

class ProfileStateNotifier extends StateNotifier<ProfileModel?> {
  final Ref ref;

  ProfileStateNotifier(this.ref) : super(null) {
    ref.listen(authStateProvider, (previous, next) async {
      final authorized = next as bool?;
      if (authorized == null) { return; }
      // ログアウトしたらプロフィールをクリア
      if (!authorized) { state = null; }
    });

    ref.listen(myPostStateProvider, (previous, next) { 
      if (state == null) { return; }
      final posts = next as List<String>?;
      if (posts == null) { return; }
      state = ProfileModel(name: state!.name, totalPost: posts.length);
    });
  }

  Future<ProfileModel> update(ProfileModel profile) async {
    state = profile;
    return state!;
  }
}
