import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _init(),);
  }

  Future<void> _init() async {
    final status = await AuthService.checkAuthStatus();

    if (!mounted) return;

    switch (status) {
      case AuthStatus.authenticated:
        context.goNamed('home');
        break;

      case AuthStatus.profileIncomplete:
        context.goNamed('profile');
        break;

      case AuthStatus.unauthenticated:
        context.goNamed('login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
