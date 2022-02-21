import 'package:flutter/material.dart';
import 'package:provider_sample/provider/auth_change_notifier.dart';
import 'package:provider_sample/provider/post_change_notifier.dart';

class Profile {
  Profile({String? name, int? totalPost}) {
    if (name != null) { this.name = name; }
    if (totalPost != null) { this.totalPost = totalPost; }
  }
  String name = "Nickname";
  int totalPost = 0;
}

class ProfileChangeNotifier with ChangeNotifier {
  final LOGOUT_PROFILE = Profile(name: "ログインしてください", totalPost: 0);
  var _profile = Profile(name: "Sudo Takuya");
  Profile get profile => isLogin ? _profile : LOGOUT_PROFILE;
  bool isLogin = true;

  void update(AuthChangeNotifier authChangeNotifier, PostChangeNotifier postChangeNotifier) {
    _profile.totalPost = postChangeNotifier.posts.length;
    isLogin = authChangeNotifier.authorized;
    notifyListeners();
  }
}
