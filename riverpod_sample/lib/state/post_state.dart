import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/state/auth_state.dart';
import 'package:riverpod_sample/repositories/post_repository.dart';

final myPostStateProvider = StateNotifierProvider<PostStateNotifier, List<String>>((ref) {
  return PostStateNotifier(ref);
});
// NOTE: 同じ構造を持つ状態を作れる
final trendPostStateProvider = StateNotifierProvider<PostStateNotifier, List<String>>((ref) {
  return PostStateNotifier(ref);
});

class PostStateNotifier extends StateNotifier<List<String>> {
  final Ref ref;

  PostStateNotifier(this.ref) : super(<String>[]) {
    ref.listen(authStateProvider, (previous, next) async {
      final authorized = next as bool?;
      if (authorized == null) { return; }
      // ログアウトしたら投稿をクリア
      if (!authorized) { state = <String>[]; }
    });
  }

  Future<void> set(List<String> posts) async {
    state = posts;
    return;
  }

  Future<List<String>> add(String post) async {
    state = await PostRepository().addPost(post);
    return state;
  }
}
