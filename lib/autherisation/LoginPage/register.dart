import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/models/user_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text('Registration')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Role'),
                value: _role,
                items: ['Employee', 'Manager', 'Admin'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _role = newValue!;
                  });
                },
                validator: (value) => value == null ? 'Select a role' : null,
                onSaved: (value) => _role = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter first name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? 'Enter last name' : null,
                onSaved: (value) => _lastName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter phone number' : null,
                onSaved: (value) => _phoneNo = value!,
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
                onSaved: (value) => _email = value!,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onSaved: (value) => _password = value!,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: widget.showLoginPage,
                child: RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(text: "Already have an account? "),
                    TextSpan(
                        text: "Login Now",
                        style: TextStyle(color: Colors.lightBlue))
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
