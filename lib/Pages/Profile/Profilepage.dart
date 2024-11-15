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
  String? _userRole;

  Future<void> getUserRole() async {
    UserService userService = UserService();
    String? role = await userService.fetchUserRole(); // Fetch the user role
    setState(() {
      _userRole = role; // Store it in the state to be used in the UI
    });
  }

  void _sendEmail() async {
    final String email = 'yash05080@gmail.com';
    final String subject = 'Subject Here'; // You can set a default subject
    final String body = 'Message Here'; // You can set a default message

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull('subject=$subject&body=$body'),
    );

    // Launch the email app
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  void initState() {
    super.initState();
    getUserRole(); // Fetch the user role when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase
    User? currentUser = _auth.currentUser;

    // Fallback values if user info is not available
    String userName = currentUser?.displayName ?? 'No Name';
    String userEmail = currentUser?.email ?? 'No Email';
    String userRole = _userRole ??
        "loading..."; // You can replace it with data from Firestore
    int completedTasks = 25; // Example static data; Fetch from database

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //profile pic
              const Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/demo.JPG'),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              // User Details Section
              _buildUserInfo(userName, userEmail, userRole, completedTasks),

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
                        // Navigate to the freelancing comments page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PostHistory()));
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
                                builder: (context) => const TaskHistoryPage()));
                        // Navigate to tasks history page
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
                        // _sendEmail();
                        // Navigate to report page
                      },
                    ),
                    _buildProfileOption(
                      context,
                      'Update Profile',
                      Icons.history,
                      () {
                        // Navigate to tasks history page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProfilePage()));
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
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
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
