import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:roupa_nossa/screens/auth/login/login_screen.dart';
import 'package:roupa_nossa/screens/main/main_view.dart';
import 'package:roupa_nossa/screens/onboarding/onboarding_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roupa_nossa/screens/home/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final nome = prefs.getString('nome') ?? '';

    await Future.delayed(const Duration(seconds: 2));

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen(userName: nome)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SizedBox(
        width: 300,
        height: 300,
        child: LottieBuilder.asset('assets/Lottie/animacao.json'),
      ),
      splashIconSize: 400,
      nextScreen: const OnboardingScreen(),
      backgroundColor: Color(0xFF2196F3),
      duration: 3000,
    );
  }
}
