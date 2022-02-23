import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/viewmodel/auth_viewmodel.dart';
import 'package:riverpod_sample/viewmodel/profile_viewmodel.dart';
import 'package:riverpod_sample/repositories/post_repository.dart';

final myPostViewModelProvider = StateNotifierProvider<PostViewModel, List<String>>((ref) {
  return PostViewModel(ref);
});
// NOTE: 同じ構造を持つ状態を作れる
final trendPostStateProvider = StateNotifierProvider<PostViewModel, List<String>>((ref) {
  return PostViewModel(ref);
});

class PostViewModel extends StateNotifier<List<String>> {
  final Ref ref;

  PostViewModel(this.ref) : super(<String>[]) {
    ref.listen(authViewModelProvider, (previous, next) async {
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
