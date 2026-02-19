import 'package:demo_phone_google_auth/bloc/auth/auth_event.dart';
import 'package:demo_phone_google_auth/bloc/auth/auth_state.dart';
import 'package:demo_phone_google_auth/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/auth_response_model.dart';
import '../../firebase/google_auth_service.dart';
import '../../utils/token_storage.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  bool _isGoogleLoginInProgress = false;
  AuthBloc() : super(AuthInitial()){
   on<SendOtpEvent>((event, emit) async {
     emit(AuthLoading(isButtonLoading: true));
     try {
       final response = await AuthRepository.sendOtpRepository(event.phone);
       emit(AuthSuccess(
         data: response,
         isGoogleLogin: false, )
       );
     } catch (e) {
       emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
     }
   },);
   on<VerifyOtpEvent>((event, emit) async {
     emit(AuthLoading(isButtonLoading: true));
     try {
       final response = await AuthRepository.verifyOtpRepository(event.phone, event.otp);
       await TokenStorage().saveTokens(
         accessToken: response.accessToken!,
         refreshToken: response.refreshToken!,
       );
       emit(AuthSuccess(
         data: response,
         isGoogleLogin: false, )
       );
     } catch (e) {
       emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
     }
   },);
   on<GoogleLoginRequestedEvent>((event, emit) async {

     if (_isGoogleLoginInProgress) {
       emit(
         AuthMessage(
           "Google sign-in already in progress, please wait…",
         ),
       );
       return;
     }

     _isGoogleLoginInProgress = true;
     emit(AuthLoading(isGoogle: true));

     try {
       final response = await AuthRepository.loginWithGoogleRepository();

       await TokenStorage().saveTokens(
         accessToken: response.accessToken!,
         refreshToken: response.refreshToken!,
       );

       emit(
         AuthSuccess(
           data: response,
           isGoogleLogin: true,
         ),
       );
     } catch (error) {
       emit(AuthFailure(error.toString().replaceAll('Exception: ', '')));
     } finally {
       _isGoogleLoginInProgress = false;
     }
   });


  }


}