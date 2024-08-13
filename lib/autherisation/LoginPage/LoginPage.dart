import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:corporate_manager/autherisation/LoginPage/forgotpass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        password: _passwordController.text.trim(),
      );
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
      backgroundColor: HexColor("#fff8f5"),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Welcome back user",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 101, 67, 33),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                // welcome image
                SvgPicture.asset(
                  'assets/icons/login.svg',
                  height: 200, // Adjust the size as needed
                ),
                SizedBox(height: 40,),

                // username textfeild

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
                          labelText: "username",
                          labelStyle: const TextStyle(
                              fontSize: 16, color: Colors.brown),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.brown, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 101, 67, 33),
                              fontSize: 18),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 101, 67, 33),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // password textfeild
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: _passwordController,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 101, 67, 33),
                      ),
                      cursorColor: const Color.fromARGB(255, 101, 67, 33),
                      cursorErrorColor: Colors.red,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                          labelText: "password",
                          labelStyle: const TextStyle(
                              fontSize: 16, color: Colors.brown),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 101, 67, 33),
                            ),
                            onPressed: _toggleVisibility,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.brown, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 101, 67, 33),
                              fontSize: 18),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 101, 67, 33),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                //forgot password

                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgetPass();
                            }));
                          },
                          child: Text(
                            "forgot password?",
                            style: TextStyle(color: HexColor("214365"),fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                //sign in button

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
                          side: BorderSide(
                            color: Color.fromARGB(255, 101, 67, 33),
                            width: 1.0,
                          ),
                        ),
                        onPressed: () {
                          signin();
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                //register option

                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                  child: InkWell(
                    onTap: widget.showRegisterPage,
                    child: RichText(
                      text:  TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.brown)),
                        TextSpan(
                            text: "Register Now",
                            style: TextStyle(color: HexColor("800000"),fontWeight: FontWeight.w600),)
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
