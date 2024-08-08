import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
      },
      color: Colors.indigo,
      child: const Text("log out"),
    );
  }
}
