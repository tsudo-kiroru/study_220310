import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/repositories/auth_repository.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  return AuthViewModel(ref);
});

class AuthViewModel extends StateNotifier<bool> {
  AuthViewModel(this.ref) : super(false);

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
