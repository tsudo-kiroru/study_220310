import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/repositories/auth_repository.dart';

final authStore = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier(this.ref) : super(false);

  final Ref ref;

  void updateAuthorize(bool isAuthorized) {
    state = isAuthorized;
  }

  Future<bool> login() async {
    final authorized = await AuthRepository().login();
    state = authorized;
    return state;
  }

  Future<void> logout() async {
    await AuthRepository().logout();
    state = false;
  }
}
