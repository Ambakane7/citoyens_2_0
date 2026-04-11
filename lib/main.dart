import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:womentech/ONBOARDING/onboradingscreen.dart';
import 'package:womentech/splashscreen.dart';


import 'Pages/homepage.dart';
import 'auth/auth_gate.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CITOYEN 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: Onboradingscreen()
      //const SplashScreen(),
    );
  }
}
