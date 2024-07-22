import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login successful"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          color: Colors.red,
          child: Text("log out"),
        ),
      ),
    );
  }
}
