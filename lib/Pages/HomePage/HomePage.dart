import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/HomePage/adminhome.dart';
import 'package:corporate_manager/Pages/HomePage/employeehome.dart';
import 'package:corporate_manager/Pages/HomePage/managerhome.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      return doc['role'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DashBoard')),
      body: FutureBuilder<String?>(
        future: getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User role not found'));
          } else {
            String role = snapshot.data!;
            if (role == "Admin") {
              return const AdminDashBoard();
            } else if (role == "Manager") {
              return const ManagerDashBoard();
            } else {
              return const EmployeeDashBoard();
            }
          }
        },
      ),
    );
  }
}
