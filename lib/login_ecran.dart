import 'package:application_des_activites_mai/list_activites_ecran.dart';
import 'package:application_des_activites_mai/widget/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginEcran extends StatelessWidget {
  const LoginEcran({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInWidget();
        }
        return ListActiviteEcran(currentIndex: 0, email: snapshot.data!.email!);
      },
    );
  }
}