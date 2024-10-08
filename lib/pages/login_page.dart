import 'package:inkhaven/auth/auth_service.dart';
import 'package:inkhaven/components/loading_circle.dart';
import 'package:inkhaven/components/my_button.dart';
import 'package:inkhaven/components/my_textfield.dart';
import 'package:inkhaven/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //log-in
  void login() async {
    // Check if email and password fields are empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Please enter both email and password."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return; // Stop further execution if fields are empty
    }

    // Show loading indicator
    showLoadingCircle(context);

    try {
      // Attempt login
      await _auth.loginEmailPassword(
          emailController.text, passwordController.text);

      // Hide loading indicator
      if (mounted) hideLoadCircle(context);

      // Navigate to the home page if login is successful
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } catch (e) {
      // Hide loading indicator
      if (mounted) hideLoadCircle(context);

      // Show error message
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo
          Icon(
            Icons.lock_open_rounded,
            size: 100,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          SizedBox(
            height: 25,
          ),

          //welcome msg
          Text(
            'Welcome back, you\'ve been missed!',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          SizedBox(
            height: 25,
          ),

          //email
          MyTextField(
              controller: emailController,
              hintText: 'Enter the email',
              obscureText: false),
          SizedBox(
            height: 10,
          ),

          //password
          MyTextField(
              controller: passwordController,
              hintText: 'Enter the password',
              obscureText: true),
          SizedBox(
            height: 15,
          ),

          //sign-in
          MyButton(
              onTap: () {
                login();
              },
              text: 'Sign-In'),

          SizedBox(
            height: 25,
          ),

          //register
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not a member?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  'Register now',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
