import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopsie/views/screens/auth/login_screen.dart';
import 'package:loopsie/views/screens/auth/signup_screen.dart';

import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(
        seconds: 1,
      ),
      () => Get.to(LoginScreen()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/images/loopsie.png'),
      ),
    );
  }
}
