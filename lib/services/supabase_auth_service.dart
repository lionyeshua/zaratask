import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaratask/models/api_response_model.dart';
import 'package:zaratask/core/utils/service_locator.dart';

class SupabaseAuthService {
  SupabaseAuthService(this._api);

  final GoTrueClient _api;

  /// true: The value is considered the "same" as the previous one and is
  /// filtered out of the stream
  ///
  /// false: The value is considered "different" and is emitted to downstream
  /// listeners
  ///
  Stream<Map<String, dynamic>?> get user => _api.onAuthStateChange
      .map((event) => event.session?.user.toJson())
      .distinct((previous, next) {
        if (previous == null && next == null) return true;
        if (previous == null || next == null) return false;

        // Compare relevant user fields that you care about
        // Add more properties for comparison as needed.
        return previous['id'] == next['id'] &&
            previous['email'] == next['email'];
      });

  Future<ApiResponse<void>> signInWithEmailAndOtp(String email) async {
    final debugMessage = 'signInWithEmailOtp($email)';

    try {
      ServiceLocator.logger.d(debugMessage);
      await _api.signInWithOtp(email: email);
      return ApiResponse.success();
    } on AuthException catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(
        httpStatusCode: e.statusCode,
        message: e.message,
      );
    } on Exception catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(message: 'Unexpected error');
    }
  }

  Future<ApiResponse<void>> signOut() async {
    const debugMessage = 'signOut()';

    try {
      ServiceLocator.logger.d(debugMessage);
      await _api.signOut();
      return ApiResponse.success();
    } on AuthException catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(
        httpStatusCode: e.statusCode,
        message: e.message,
      );
    } on Exception catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(message: 'Unexpected error');
    }
  }

  Future<ApiResponse<void>> updateEmail(String email) async {
    final debugMessage = 'updateEmail($email)';

    try {
      ServiceLocator.logger.d(debugMessage);
      await _api.updateUser(UserAttributes(email: email));
      return ApiResponse.success();
    } on AuthException catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(
        httpStatusCode: e.statusCode,
        message: e.message,
      );
    } on Exception catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(message: 'Unexpected error');
    }
  }

  Future<ApiResponse<void>> verifyOtpForEmailUpdate({
    required String email,
    required String token,
  }) async {
    final debugMessage =
        'verifyOtpForEmailUpdate(email: $email, token: $token)';

    try {
      ServiceLocator.logger.d(debugMessage);
      await _api.verifyOTP(
        email: email,
        token: token,
        type: OtpType.emailChange,
      );
      return ApiResponse.success();
    } on AuthException catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(
        httpStatusCode: e.statusCode,
        message: e.message,
      );
    } on Exception catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(message: 'Unexpected error');
    }
  }

  Future<ApiResponse<void>> verifyOtpForEmailSignIn({
    required String email,
    required String token,
  }) async {
    final debugMessage =
        'verifyOtpForEmailSignIn(email: $email, token: $token)';

    try {
      ServiceLocator.logger.d(debugMessage);
      await _api.verifyOTP(email: email, token: token, type: OtpType.email);
      return ApiResponse.success();
    } on AuthException catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(
        httpStatusCode: e.statusCode,
        message: e.message,
      );
    } on Exception catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return ApiResponse.error(message: 'Unexpected error');
    }
  }
}
