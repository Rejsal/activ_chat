import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/screens/home_screen.dart';
import 'package:activ_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, user, _) {
      if (user.status == Status.loading) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      } else {
        if (user.status == Status.authenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      }
    });
  }
}
