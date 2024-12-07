import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/Profile/feature%20pages/PostHistory.dart';
import 'package:corporate_manager/Pages/Profile/feature%20pages/Updateprofile.dart';
import 'package:corporate_manager/Pages/Profile/feature%20pages/taskhistory.dart';
import 'package:corporate_manager/Pages/Profile/widgets/logoutbutton.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/fetchrole.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userRole;
  String? _profilePictureUrl;
  int _completedTasks = 1;
  

  Future<void> _fetchCompletedTasks() async {
    try {
      User? currentUser = _auth.currentUser; // Get current user
      if (currentUser == null) return;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tasks') // Adjust collection name if needed
          .where('assignee', isEqualTo: currentUser.uid) // User's UID
          .where('status', isEqualTo: 'Completed') // Completed tasks only
          .get();
      

      setState(() {
        print(currentUser.uid);
        _completedTasks = querySnapshot.docs.length; // Count completed tasks
      });
    } catch (error) {
      print('Error fetching completed tasks: $error');
    }
  }

  Future<void> getUserRole() async {
    UserService userService = UserService();
    String? role = await userService.fetchUserRole(); // Fetch the user role

    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;

        setState(() {
          _userRole = role; // Store role in state
          _profilePictureUrl = userData?['profilePicture']; // Get profile pic
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCompletedTasks();
    getUserRole(); // Fetch the user role and profile picture
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase
    User? currentUser = _auth.currentUser;

    // Fallback values if user info is not available
    String userName = currentUser?.displayName ?? 'No Name';
    String userEmail = currentUser?.email ?? 'No Email';
    String userRole = _userRole ?? "loading...";
    int completedTasks = 25; // Example static data; Fetch from database

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: _profilePictureUrl != null &&
                          _profilePictureUrl!.isNotEmpty
                      ? NetworkImage(_profilePictureUrl!)
                      : AssetImage('assets/profile.jpeg') as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              // User Details Section
              _buildUserInfo(userName, userEmail, userRole, _completedTasks),
              const SizedBox(height: 20),
              // Options List
              Expanded(
                child: ListView(
                  children: [
                    _buildProfileOption(
                      context,
                      'Your Posts',
                      Icons.comment,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostHistory()),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context,
                      'Tasks History',
                      Icons.task_alt,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaskHistoryPage()),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context,
                      'My Points',
                      Icons.stars,
                      () {
                        // Navigate to the points page
                      },
                    ),
                    _buildProfileOption(
                      context,
                      'Report',
                      Icons.report,
                      () {
                        // Navigate to report page
                      },
                    ),
                    _buildProfileOption(
                      context,
                      'Update Profile',
                      Icons.history,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfilePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    const LogOutButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // User Info Widget
  Widget _buildUserInfo(
      String name, String email, String role, int completedTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name: $name',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Email: $email',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          'Role: $role',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Completed Tasks: $completedTasks',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Profile Option Widget
  Widget _buildProfileOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.brown),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
