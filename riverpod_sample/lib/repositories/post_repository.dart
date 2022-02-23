import 'package:hooks_riverpod/hooks_riverpod.dart';

// 本当はAPIを想定したいがとりあえずグローバル変数にして擬似的に表現
List<String> remotePosts = <String>[];

class PostRepository {
  Future<List<String>> fetchMine() async {
    return remotePosts;
  }

  Future<List<String>> addPost(String post) async {
    remotePosts = [...remotePosts, post];
    return remotePosts;
  }
}
