import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _displayName;
  String? _email;
  String? _phoneNo;
  String? _role;
  String? _profilePictureUrl;

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _displayName = currentUser.displayName ?? '';
      _email = currentUser.email;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;

        if (mounted && userData != null) {
          setState(() {
            _displayNameController.text = _displayName!;
            _phoneNoController.text = userData['phoneNo'] ?? '';
            _roleController.text = userData['role'] ?? '';
            _profilePictureUrl = userData['profilePicture'] ?? '';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _displayNameController.text = '';
            _phoneNoController.text = '';
            _roleController.text = '';
            _profilePictureUrl = '';
          });
        }
      }
    }
  }

  Future<String> _uploadProfilePicture() async {
  if (_selectedImage == null) {
    throw Exception("No image selected for upload");
  }

  try {
    print("Starting profile picture upload...");
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    // Updated file path to include a unique file name
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profilePictures')
        .child(currentUser.uid)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    final uploadTask = storageRef.putFile(_selectedImage!);

    uploadTask.snapshotEvents.listen((event) {
      print(
          "Progress: ${(event.bytesTransferred / event.totalBytes) * 100}%");
    });

    await uploadTask.whenComplete(() => print("Upload complete!"));

    final downloadUrl = await storageRef.getDownloadURL();
    print("Download URL: $downloadUrl");

    return downloadUrl;
  } catch (e) {
    print("Error in _uploadProfilePicture: $e");
    rethrow;
  }
}


  Future<void> _pickImage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      print("Opening image picker...");
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print("Image selected: ${pickedFile.path}");
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error in _pickImage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        print("Updating user profile...");
        User? currentUser = _auth.currentUser;

        if (currentUser != null) {
          String? profilePictureUrl = _selectedImage != null
              ? await _uploadProfilePicture()
              : _profilePictureUrl;

          await currentUser.updateDisplayName(_displayNameController.text);

          await _firestore.collection('users').doc(currentUser.uid).set({
            'phoneNo': _phoneNoController.text,
            'role': _roleController.text,
            'profilePicture': profilePictureUrl,
          }, SetOptions(merge: true));

          print("Profile updated successfully.");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile updated successfully')),
            );
          }
        }
      } catch (e) {
        print("Error in _updateUserProfile: $e");
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
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (_profilePictureUrl != null &&
                                  _profilePictureUrl!.isNotEmpty)
                              ? NetworkImage(_profilePictureUrl!)
                                  as ImageProvider
                              : AssetImage('assets/profile.jpeg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.brown),
                        onPressed: _isLoading ? null : _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
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
