import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _usernameController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                e.message.toString(),
                style: TextStyle(
                    color: HexColor("C00000"),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              backgroundColor: HexColor("FFD078"),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(
              color: Color.fromARGB(255, 101, 67, 33),
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          SvgPicture.asset(
            'assets/icons/forgotpass.svg',
            height: 200, // Adjust the size as needed
          ),
          const SizedBox(
            height: 40,
          ),
          const SizedBox(
            height: 25,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Dear user, please enter your email down to recieve the reset password link",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 101, 67, 33),
              ),
              softWrap: true,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _usernameController,
                style: const TextStyle(
                  color: Color.fromARGB(255, 101, 67, 33),
                ),
                cursorColor: Colors.brown,
                decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 101, 67, 33),
                    ),
                    labelText: "Email address",
                    labelStyle:
                        const TextStyle(fontSize: 16, color: Colors.brown),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.brown, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 101, 67, 33), fontSize: 18),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 101, 67, 33), width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          //reset pass button

          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    shadowColor: Colors.transparent,
                    side: const BorderSide(
                      color: Color.fromARGB(255, 101, 67, 33),
                      width: 1.0,
                    ),
                  ),
                  onPressed: () {
                    passwordReset();
                  },
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
