import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inkhaven/auth/auth_gate.dart';
import 'package:inkhaven/pages/splash_screen.dart';
import 'package:inkhaven/services/database_provider.dart';
import 'package:inkhaven/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyArBwFzgtylhdGUt-RskBZNYSTIJ_01mfE",
          appId: "1:689563463059:android:732d65a6f2a39b72f2cc66",
          messagingSenderId: "689563463059",
          projectId: "apps-ee4d4",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DatabaseProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: SplashScreen(), // Set the SplashScreen as the initial route
      routes: {
        '/auth': (context) => AuthGate(), // Define the AuthGate route
        // Add other routes as needed
      },
    );
  }
}
