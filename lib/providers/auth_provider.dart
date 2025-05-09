import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:zaratask/models/user_model.dart';
import 'package:zaratask/services/supabase_auth_service.dart';
import 'package:zaratask/core/utils/service_locator.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required SupabaseAuthService auth}) {
    _auth = auth;
    _init();
  }

  late SupabaseAuthService _auth;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  late User _user;
  User get user => _user;

  void _init() {
    _auth.user.listen((json) {
      ServiceLocator.logger.i(
        'User stream updated id: ${json?['id']}, email:  ${json?['email']})',
      );

      if (json == null) {
        _isAuthenticated = false;
      } else {
        _isAuthenticated = true;
        _user = User.fromJson(json);
      }
      notifyListeners();
    });
  }

  Future<void> signInWithEmailAndOtp(
    BuildContext context, {
    required String email,
  }) async {
    final response = await _auth.signInWithEmailAndOtp(email);
    if (response.successful) {
      if (context.mounted) {
        // TODO(red): add an enum of auth status and have the go router redirect
        //  trigger all of these navigations just like authenticated does for
        //  sign in.
        //  This will get rid of having to navigate logic in the provider.
        await context.push('/verify-sign-in', extra: email);
      } else {
        ServiceLocator.messenger.showError(
          'Could not navigate to verification page',
        );
      }
    } else {
      ServiceLocator.messenger.showError(
        response.message ?? 'This is not good',
      );
    }
  }

  Future<void> signOut() async {
    final response = await _auth.signOut();
    if (!response.successful) {
      ServiceLocator.messenger.showError(
        response.message ?? 'This is not good',
      );
    }
  }

  Future<void> updateEmail(
    BuildContext context, {
    required String email,
  }) async {
    final response = await _auth.updateEmail(email);
    if (response.successful) {
      if (context.mounted) {
        await context.push('/profile/verify-email', extra: email);
      } else {
        ServiceLocator.messenger.showError(
          'Could not navigate to verification page',
        );
      }
    } else {
      ServiceLocator.messenger.showError(
        response.message ?? 'This is not good',
      );
    }
  }

  Future<void> verifyOtpForEmailUpdate(
    BuildContext context, {
    required String email,
    required String token,
  }) async {
    final response = await _auth.verifyOtpForEmailUpdate(
      email: email,
      token: token,
    );
    if (response.successful) {
      if (context.mounted) {
        await context.push('/profile');
      } else {
        ServiceLocator.messenger.showError(
          'Could not navigate to profile page',
        );
      }
    } else {
      ServiceLocator.messenger.showError(
        response.message ?? 'This is not good',
      );
    }
  }

  Future<void> verifyOtpForEmailSignIn({
    required String email,
    required String token,
  }) async {
    final response = await _auth.verifyOtpForEmailSignIn(
      email: email,
      token: token,
    );
    if (!response.successful) {
      ServiceLocator.messenger.showError(
        response.message ?? 'This is not good',
      );
    }
  }
}
