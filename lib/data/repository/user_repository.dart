import 'package:demo_phone_google_auth/data/api/user_api.dart';
import 'package:demo_phone_google_auth/data/models/user_response_model.dart';

class UserRepository {
  static Future<UserResponseModel> getUserProfileRepository() async {
    return await UserApi.getUserApi();
  }
}

