import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/models/profile_model.dart';

// 本当はAPIを想定したいがとりあえずグローバル変数にして擬似的に表現
final PROFILE = ProfileModel(name: "Sudo Takuya");

class ProfileRepository {
  Future<ProfileModel?> fetch() async {
    return PROFILE;
  }
}
