import 'package:corporate_manager/models/user_class.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userRole;
  User? _currentUser;
  String get userRole => _userRole ?? 'User';
  User? get currentUser => _currentUser;
  bool _isFetchingRole = false;
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        _user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void updateProfilePicture(String newUrl) {
    if (_user != null) {
      _user = UserModel(
        uid: _user!.uid,
        role: _user!.role,
        name: _user!.name,
        lastName: _user!.lastName,
        email: _user!.email,
        phoneNo: _user!.phoneNo,
        profilePictureUrl: newUrl,
      );
      notifyListeners();
    }
  }

  UserProvider() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    // Set the current user
    _currentUser = _auth.currentUser;

    // Fetch user role if a user is signed in
    if (_currentUser != null) {
      await _fetchUserRole();
    } else {
      _userRole = 'Guest';
      notifyListeners();
    }
  }

  Future<void> _fetchUserRole() async {
    // Avoid fetching role if already in process
    if (_isFetchingRole) return;
    _isFetchingRole = true;

    try {
      if (_currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(_currentUser!.uid).get();

        if (userDoc.exists && userDoc['role'] != null) {
          _userRole = userDoc['role'] as String;
        } else {
          _userRole = 'User'; // Default role if none found
        }
        notifyListeners(); // Notify consumers of the change
      } else {
        print('No user is currently signed in');
        _userRole = 'Guest'; // Indicate a guest role if not signed in
      }
    } catch (e) {
      print('Error fetching user role: $e');
    } finally {
      _isFetchingRole = false;
    }
  }

  // Refresh the role in case it might have changed, e.g., on a role update
  Future<void> refreshUserRole() async {
    await _fetchUserRole();
  }
}
