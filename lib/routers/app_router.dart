import 'package:demo_phone_google_auth/ui/screens/auth/login_screen.dart';
import 'package:demo_phone_google_auth/ui/screens/auth/otp_verify_screen.dart';
import 'package:demo_phone_google_auth/ui/screens/user/create_profile_screen.dart';
import 'package:go_router/go_router.dart';

import '../ui/screens/home/home_screen.dart';
import '../ui/screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder:  (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder:  (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/otpVerify',
          name: 'otpVerify',
          builder:  (context, state) {
            final phoneNumber = state.extra as String;
            return OtpVerifyScreen(phoneNumber: phoneNumber,);
          },
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder:  (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder:  (context, state) => CreateProfileScreen(),
        ),
      ]
  );
}