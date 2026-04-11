import 'dart:async';
import 'package:flutter/material.dart';
import 'package:womentech/Pages/homepage.dart';
import 'package:womentech/auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [

              // IMAGE (prend l'espace dispo)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    'lib/images/logo original .png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // TEXTE

            ],
          ),
        )
      ),
    );
  }
}
