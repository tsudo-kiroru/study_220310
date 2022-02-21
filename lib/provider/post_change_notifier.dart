import 'package:flutter/material.dart';
import 'package:provider_sample/provider/auth_change_notifier.dart';

class PostChangeNotifier with ChangeNotifier {
  var posts = <String>[];
  var _posts = <String>[];
  var _visible = true;

  void add() {
    _posts = _posts + ["ツイート: ${_posts.length + 1}"];
    posts = _visible ? _posts : <String>[];
    notifyListeners();
  }

  void updateVisibility(AuthChangeNotifier authChangeNotifier) {
    _visible = authChangeNotifier.authorized;
    posts = _visible ? _posts : <String>[];
    notifyListeners();
  }
}
