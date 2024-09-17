import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch the current user's role from Firestore
  Future<String?> fetchUserRole() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        // Fetch the user's document from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        // Check if the document exists and return the 'role'
        if (userDoc.exists) {
          String userRole = userDoc['role']; // Assuming 'role' field exists
          return userRole;
        } else {
          print("User document does not exist");
          return null;
        }
      } catch (e) {
        print("Error fetching user role: $e");
        return null;
      }
    } else {
      print("No current user logged in");
      return null;
    }
  }
}
