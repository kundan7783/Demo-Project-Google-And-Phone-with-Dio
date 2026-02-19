import 'dart:convert';
import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'token_storage.dart';

class AuthService {
  static final TokenStorage _tokenStorage = TokenStorage();

  /// 🔥 Splash se sirf ye call karo
  static Future<AuthStatus> checkAuthStatus() async {
    String? accessToken = await _tokenStorage.getAccessToken();

    if (accessToken == null) {
      return AuthStatus.unauthenticated;
    }

    Map<String, dynamic>? payload = _decodeToken(accessToken);

    if (payload == null) {
      await _tokenStorage.clearTokens();
      return AuthStatus.unauthenticated;
    }

    // ⏳ Expired?
    if (_isExpired(payload)) {
      bool refreshed = await _refreshToken();

      if (!refreshed) {
        return AuthStatus.unauthenticated;
      }

      accessToken = await _tokenStorage.getAccessToken();
      payload = _decodeToken(accessToken!);

      if (payload == null) {
        return AuthStatus.unauthenticated;
      }
    }

    final bool profileExists = payload['profileExists'] ?? false;

    if (profileExists) {
      return AuthStatus.authenticated;
    } else {
      return AuthStatus.profileIncomplete;
    }
  }

  // 🔐 Decode JWT
  static Map<String, dynamic>? _decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );

      return jsonDecode(payload);
    } catch (_) {
      return null;
    }
  }

  static bool _isExpired(Map<String, dynamic> payload) {
    final exp = payload['exp'];
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= exp;
  }

  // 🔁 Refresh using Dio
  static Future<bool> _refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await DioClient.refreshDio.post(
        "/api/auth/refresh-token",
        data: {"refreshToken": refreshToken},
      );

      final newAccess = response.data['accessToken'];
      final newRefresh = response.data['refreshToken'];

      await _tokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      return true;
    } catch (_) {
      await _tokenStorage.clearTokens();
      return false;
    }
  }
}

/// 🔥 Clean navigation state
enum AuthStatus {
  unauthenticated,
  profileIncomplete,
  authenticated,
}
