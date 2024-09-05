import 'package:inkhaven/auth/login_or_regsiter_page.dart';
import 'package:inkhaven/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inkhaven/auth/login_or_regsiter_page.dart';
import 'package:inkhaven/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return LoginOrRegister();
            }
          } else {
            // Show a loading spinner while waiting for the auth state
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
