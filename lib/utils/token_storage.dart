import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final String _access = 'access_token';
  final String _refresh = 'refresh_token';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.write(key: _access, value: accessToken);
    await secureStorage.write(key: _refresh, value: refreshToken);
  }
  Future<String?> getAccessToken() async => await secureStorage.read(key: _access);
  Future<String?> getRefreshToken() async => await secureStorage.read(key: _refresh);
  Future<void> clearTokens() async => await secureStorage.deleteAll();

}
