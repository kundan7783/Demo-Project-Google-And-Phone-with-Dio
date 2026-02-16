import 'package:demo_phone_google_auth/data/models/user_response_model.dart';
import 'package:demo_phone_google_auth/utils/dio_client.dart';

class UserApi {
  static Future<UserResponseModel> getUserApi() async {
    try {
      final response = await DioClient.dio.get('/api/user');
      return UserResponseModel.formJson(response.data);
    } catch (error) {
      rethrow;
    }
  }
}
