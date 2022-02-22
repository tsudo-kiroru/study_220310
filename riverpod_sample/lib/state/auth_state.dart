import 'package:hooks_riverpod/hooks_riverpod.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<bool> {
  AuthStateNotifier(this.ref) : super(false);

  final Ref ref;

  void updateAuthorize(bool isAuthorized) {
    state = isAuthorized;
  }
}
