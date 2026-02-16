import 'dart:async';

import 'package:demo_phone_google_auth/data/models/auth_response_model.dart';

import '../../firebase/google_auth_service.dart';
import '../api/auth_api.dart';

class AuthRepository {
  static Future<AuthResponseModel> sendOtpRepository(String phone) async {
     return await AuthApi.sendOtpApi(phone);
   }
  static Future<AuthResponseModel> verifyOtpRepository(String phone,String otp) async {
     return await AuthApi.verifyOtpApi(phone, otp);
  }
  static Future<AuthResponseModel> loginWithGoogleRepository() async {
    try{
      final firebaseToken = await GoogleAuthService.getFirebaseToken();
      return await AuthApi.loginWithGoogleApi(firebaseToken!).timeout(const Duration(seconds: 50));
    }catch (e) {
      if (e is TimeoutException) {
        throw "Login timed out. Check your internet.";
      }
      throw "Google login failed. Please try again.";
    }


  }

}
