import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userRole;
  String get userRole => _userRole ?? 'User';
  bool _isFetchingRole = false;

  UserProvider() {
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    // Avoid fetching role if already in process
    if (_isFetchingRole) return;
    _isFetchingRole = true;

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

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
