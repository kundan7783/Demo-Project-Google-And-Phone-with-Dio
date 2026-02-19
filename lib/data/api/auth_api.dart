import 'package:demo_phone_google_auth/data/models/auth_response_model.dart';
import 'package:demo_phone_google_auth/utils/dio_client.dart';
import 'package:dio/dio.dart';

class AuthApi {
   static Future<AuthResponseModel> sendOtpApi(String phoneNumber) async {
     try{
       final response = await DioClient.dio.post(
         '/api/auth/send-otp',
         data: {
           'phone': phoneNumber,
         },
       );
       return AuthResponseModel.fromJson(response.data);
     }on DioException catch (e) {

       // Backend ka message nikaalo
       final errorMessage =
           e.response?.data?['message'] ?? "Something went wrong";

       throw Exception(errorMessage);
     } catch (e) {
       throw Exception("Unexpected error occurred");
     }
   }
  static Future<AuthResponseModel> verifyOtpApi(String phoneNumber, String otp) async {
     try{
       final response = await DioClient.dio.post(
         '/api/auth/verify-otp',
         data: {
           'phone': phoneNumber,
           'otp_code': otp,
         },
       );
       return AuthResponseModel.fromJson(response.data);
     }on DioException catch (e) {

       // Backend ka message nikaalo
       final errorMessage =
           e.response?.data?['message'] ?? "Something went wrong";

       throw Exception(errorMessage);
     } catch (e) {
       throw Exception("Unexpected error occurred");
     }
   }
   static Future<AuthResponseModel> loginWithGoogleApi(String token) async {
      try{
        final response = await DioClient.dio.post(
          '/api/auth/google-login',
          data: {
            'token' : token
          }
        );
        return AuthResponseModel.fromJson(response.data);

      }on DioException catch (e) {
        // Backend ka message nikaalo
        final errorMessage = e.response?.data?['message'] ?? "Something went wrong";

        throw Exception(errorMessage);
      } catch (e) {
        throw Exception("Unexpected error occurred");
      }
   }
}
