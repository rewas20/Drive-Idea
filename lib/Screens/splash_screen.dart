import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:expacto_patronam/Screens/home_screen.dart';
import 'package:expacto_patronam/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routName = "SPLASH_SCREEN";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  AnimatedSplashScreen(
        splash: Lottie.asset('assets/lotties/harry_potter.json'),
        nextScreen: FirebaseAuth.instance.currentUser !=null? const HomeScreen(): const LoginScreen(),
        backgroundColor: Theme.of(context).primaryColor,
        disableNavigation: false,
        splashIconSize: double.infinity,
        duration: 4200,


      ),
    );
  }
}
