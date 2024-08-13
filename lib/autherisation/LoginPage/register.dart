import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/models/user_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String _role = 'Employee';
  String _name = '';
  String _lastName = '';
  String _email = '';
  String _phoneNo = '';
  String _password = '';

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        UserModel newUser = UserModel(
          uid: userCredential.user!.uid,
          role: _role,
          name: _name,
          lastName: _lastName,
          email: _email,
          phoneNo: _phoneNo,
        );

        FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.uid)
            .set(newUser.toMap());

        // Navigate to another page or show success message
      } catch (e) {
        print(e);
        // Handle error (e.g., show a message to the user)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Registor now",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 101, 67, 33),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //register now image
                  
                      SvgPicture.asset(
                        'assets/icons/signup.svg',
                        height: 200,
                      ),
                      SizedBox(height: 20,),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: 'Role',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 161, 117, 92))),
                          value: _role,
                          items: ['Employee', 'Manager', 'Admin'].map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(
                                role,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 101, 67, 33)),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _role = newValue!;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Select a role' : null,
                          onSaved: (value) => _role = value!,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            labelStyle:
                                TextStyle(color: Color.fromARGB(255, 161, 117, 92)),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter first name' : null,
                          onSaved: (value) => _name = value!,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 161, 117, 92))),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter last name' : null,
                          onSaved: (value) => _lastName = value!,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 161, 117, 92))),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter phone number' : null,
                          onSaved: (value) => _phoneNo = value!,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 161, 117, 92))),
                          validator: (value) => value!.isEmpty ? 'Enter email' : null,
                          onSaved: (value) => _email = value!,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 161, 117, 92))),
                          validator: (value) => value!.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          onSaved: (value) => _password = value!,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        Padding(
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
                              onPressed: _registerUser,
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.brown,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: InkWell(
                            onTap: widget.showLoginPage,
                            child: RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(color: Colors.brown)),
                                TextSpan(
                                    text: "Login Now",
                                    style: TextStyle(
                                        color: HexColor("214365"),
                                        fontWeight: FontWeight.w600))
                              ]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
