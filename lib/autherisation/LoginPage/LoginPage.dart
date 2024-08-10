import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Loginpage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const Loginpage({super.key, required this.showRegisterPage});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future signin() async {
    //loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text.trim(),
          password: _passwordController.text.trim());
//pop circular indicator
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //display error message

      displayMessage(e.code);
    }
  }

  //display a dialog box
  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("2a2438"),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                          controller: _usernameController,
                          style: TextStyle(color: HexColor("dbd8e3")),
                          cursorColor: HexColor("dbd8e3"),
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.person,
                                color: HexColor("dbd8e3"),
                              ),
                              hintText: "username",
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                          controller: _passwordController,
                          style: TextStyle(color: HexColor("dbd8e3")),
                          cursorColor: HexColor("dbd8e3"),
                          cursorErrorColor: Colors.red,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: "password",
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: HexColor("dbd8e3"),
                              ),
                              onPressed: _toggleVisibility,
                            ),
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Frosted glass effect
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      // Elevated button on top of the frosted glass effect
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            signin();
                            // Handle sign in button press
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                    onTap: widget.showRegisterPage,
                    child: const Text("Create account",
                        style: TextStyle(color: Colors.lightBlue))),
              ],
            ),
          ),
        ));
  }
}
