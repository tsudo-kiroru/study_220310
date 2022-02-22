import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/state/auth_state.dart';

class PostManager {
  PostManager({List<String>? list, bool? isLogin}) {
    if (list != null) { this.list = list; }
    if (isLogin != null) { this.isLogin = isLogin; }
  }
  var list = <String>[];
  var isLogin = true;

  List<String> get posts => isLogin ? list : <String>[];  
}

final myPostStateProvider = StateNotifierProvider<PostStateNotifier, PostManager>((ref) {
  return PostStateNotifier(ref);
});

class PostStateNotifier extends StateNotifier<PostManager> {
  final Ref ref;

  PostStateNotifier(this.ref) : super(PostManager(isLogin: true)) {
    ref.listen(authStateProvider, (previous, next) {
      final authorized = next as bool?;
      if (authorized == null) { return; }
      state.isLogin = authorized;
    });
  }

  void add() {
    // NOTE: プリミティブな値以外はstateを生成しないといけない
    state = PostManager(
      list: [...state.list, "ツイート: ${state.list.length + 1}"],
      isLogin: state.isLogin,
    );
  }
}
