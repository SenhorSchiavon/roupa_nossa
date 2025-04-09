import 'package:flutter/material.dart';
import 'package:roupa_nossa/commons/routes.dart';
import 'package:roupa_nossa/screens/auth/login/login_screen.dart';
import 'package:roupa_nossa/screens/auth/register/register_form_screen.dart';
import 'package:roupa_nossa/screens/donations/list/donations_list.dart';
import 'package:roupa_nossa/screens/home/home_view.dart';
import 'package:roupa_nossa/screens/main/main_view.dart';
import 'package:roupa_nossa/screens/onboarding/onboarding_view.dart';
import 'package:roupa_nossa/screens/splash/splash_view.dart';
import 'package:roupa_nossa/screens/welcome/welcome_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      initialRoute: NamedRoutes.splash,
      routes: {
        NamedRoutes.home: (context) => HomeView(userName: "John doe"),
        NamedRoutes.login: (context) => Container(color: Colors.green),
        NamedRoutes.register: (context) => Container(color: Colors.blue),
        NamedRoutes.profile: (context) => Container(color: Colors.yellow),
        NamedRoutes.settings: (context) => Container(color: Colors.orange),
        NamedRoutes.main: (context) => MainScreen(userName: "John doe"),
        NamedRoutes.splash: (context) => SplashView(),
        NamedRoutes.onboarding: (context) => OnboardingScreen(),
        NamedRoutes.auth: (context) => LoginScreen(),
        NamedRoutes.registerFormScreen: (context) => RegisterScreen(),
        NamedRoutes.listDonation: (context) => AllDonationsScreen(),
        NamedRoutes.welcome:
            (context) => WelcomeScreen(
              userName: "João Schiavon",
              isReturningUser: false,
              onContinue: () {
                Navigator.pushReplacementNamed(context, NamedRoutes.home);
              },
            ),
      },
    );
  }
}
