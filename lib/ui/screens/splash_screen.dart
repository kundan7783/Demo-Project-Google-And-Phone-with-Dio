
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/dio_client.dart';
import '../../utils/token_storage.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final accessToken = await _tokenStorage.getAccessToken();

    // ❌ No token → Login
    if (accessToken == null) {
      context.goNamed('login');
      return;
    }

    try {
      // 🔥 Silent protected API call
      final response = await DioClient.dio.get("/api/user");

      final bool profileExists = response.data['profileExists'] ?? false;

      // 👇 MAIN DECISION
      if (profileExists == false) {
        context.goNamed('profile'); // 👈 Create Profile
      } else {
        context.goNamed('home'); // 👈 Home
      }

    } on DioException catch (e) {
      // ❌ access + refresh dono fail
      await _tokenStorage.clearTokens();
      context.goNamed('login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircleAvatar(radius: 50,),
      ),
    );
  }
}


