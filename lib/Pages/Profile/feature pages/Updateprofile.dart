import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User details
  String? _displayName;
  String? _email;
  String? _phoneNo;
  String? _role;

  // Text controllers
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }


  // Load current user details from Firebase Authentication and Firestore
Future<void> _loadUserProfile() async {
  User? currentUser = _auth.currentUser;

  if (currentUser != null) {
    // Get details from Firebase Authentication
    _displayName = currentUser.displayName ?? '';
    _email = currentUser.email;

    // Get additional details from Firestore
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (userDoc.exists) {
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _displayNameController.text = _displayName!;
          _phoneNoController.text = userDoc['phoneNo'];
          _roleController.text = userDoc['role'];
        });
      }
    }
  }
}

// Update profile details
Future<void> _updateUserProfile() async {
  if (_formKey.currentState!.validate()) {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Update the displayName in Firebase Authentication
        await currentUser.updateDisplayName(_displayNameController.text);

        // Update other details in Firestore
        await _firestore.collection('users').doc(currentUser.uid).update({
          'phoneNo': _phoneNoController.text,
          'role': _roleController.text,
        });

        // Optionally reload the user profile to reflect changes
        await currentUser.reload();

        // Ensure the widget is still mounted before showing the SnackBar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(labelText: 'Display Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a display name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneNoController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a phone number' : null,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) => value!.isEmpty ? 'Enter a role' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserProfile,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
