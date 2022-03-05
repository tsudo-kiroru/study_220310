import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/riverpod/auth_store.dart';
import 'package:riverpod_sample/riverpod/profile_store.dart';
import 'package:riverpod_sample/repositories/post_repository.dart';

final myPostStore = StateNotifierProvider<PostNotifier, List<String>>((ref) {
  return PostNotifier(ref);
});
// NOTE: 同じ構造を持つ状態を作れる
final trendPostStore = StateNotifierProvider<PostNotifier, List<String>>((ref) {
  return PostNotifier(ref);
});

class PostNotifier extends StateNotifier<List<String>> {
  final Ref ref;

  PostNotifier(this.ref) : super(<String>[]) {
    ref.listen(authStore, (previous, next) async {
      final authorized = next as bool?;
      if (authorized == null) { return; }
      // ログアウトしたら投稿をクリア
      if (!authorized) { state = <String>[]; }
    });
  }

  Future<List<String>> fetch() async {
    final posts = await PostRepository().fetchMine();
    state = posts;
    return state;
  }

  Future<List<String>> add(String post) async {
    state = await PostRepository().addPost(post);
    return state;
  }
}
