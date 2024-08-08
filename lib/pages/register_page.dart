import 'dart:math';

import 'package:bloggers/auth/auth_service.dart';
import 'package:bloggers/components/loading_circle.dart';
import 'package:bloggers/components/my_button.dart';
import 'package:bloggers/components/my_textfield.dart';
import 'package:bloggers/services/database_services.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
//access auth service
  final _auth = AuthService();
  final _db = DatabaseServices();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  void register() async {
    if (passwordController.text == confirmPasswordController.text) {
      showLoadingCircle(context);

      try {
        await _auth.registerEmailPassword(
            emailController.text, passwordController.text);
        if (mounted) hideLoadCircle(context);

        await _db.saveUserInfoInFirebase(
            name: nameController.text, email: emailController.text);
      } catch (e) {
        if (mounted) hideLoadCircle(context);

        if (mounted) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(e.toString()),
                  ));
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Password don't match"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
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
                'Lets create an account for you',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              MyTextField(
                  controller: nameController,
                  hintText: 'Enter the name',
                  obscureText: false),
              SizedBox(
                height: 10,
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
                height: 10,
              ),
              //confirmPassword
              MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true),
              SizedBox(
                height: 15,
              ),

              //sign-up
              MyButton(
                  onTap: () {
                    register();
                  },
                  text: 'Sign-Up'),

              SizedBox(
                height: 25,
              ),

              //register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account ?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Login now ',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
