import 'package:demo_phone_google_auth/utils/token_storage.dart';
import 'package:dio/dio.dart';

class DioClient {
  static final TokenStorage _tokenStorage = TokenStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://demo-project-api-qp4q.onrender.com",
    ),
  );

  static final Dio refreshDio = Dio(
    BaseOptions(
      baseUrl: "https://demo-project-api-qp4q.onrender.com",
    ),
  );

  static void setOfInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && error.requestOptions.path != "/api/auth/refresh-token") {
            final refreshToken = await _tokenStorage.getRefreshToken();
            if (refreshToken == null) {
              await _tokenStorage.clearTokens();
              return handler.reject(error);
            }

            try {
              final response = await refreshDio.post(
                "/api/auth/refresh-token",
                data: {"refreshToken": refreshToken},
              );

              final newAccess = response.data['accessToken'];
              final newRefresh = response.data['refreshToken'];

              await _tokenStorage.saveTokens(
                accessToken: newAccess,
                refreshToken: newRefresh,
              );

              error.requestOptions.headers['Authorization'] = 'Bearer $newAccess';

              final retry = await dio.fetch(error.requestOptions);
              return handler.resolve(retry);

            } catch (_) {
              await _tokenStorage.clearTokens();
              return handler.reject(error);
            }
          }
          return handler.reject(error);
        },
      ),
    );
  }
}


