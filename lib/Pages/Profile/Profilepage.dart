import 'package:corporate_manager/Pages/Profile/feature%20pages/PostHistory.dart';
import 'package:corporate_manager/Pages/Profile/feature%20pages/Updateprofile.dart';
import 'package:corporate_manager/Pages/Profile/widgets/logoutbutton.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/fetchrole.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
    String userRole = _userRole??"loading..."; // You can replace it with data from Firestore
    int completedTasks = 25; // Example static data; Fetch from database

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //profile pic
              Center(
                  child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                    color: Colors.indigo),
              )),

              SizedBox(
                height: 20,
              ),
              // User Details Section
              _buildUserInfo(userName, userEmail, userRole, completedTasks),

              SizedBox(height: 20),

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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PostHistory()));
                      },
                    ),
                    _buildProfileOption(
                      context,
                      'My Points',
                      Icons.stars,
                      () {
                        // Navigate to the points page
                        Navigator.pushNamed(context, '/my-points');
                      },
                    ),
                    _buildProfileOption(
                      context,
                      'Report',
                      Icons.report,
                      () {
                        // Navigate to report page
                        Navigator.pushNamed(context, '/report');
                      },
                    ),
                    _buildProfileOption(
                      context,
                      'My Applications',
                      Icons.apps,
                      () {
                        // Navigate to my applications page
                        Navigator.pushNamed(context, '/my-applications');
                      },
                    ),
                    _buildProfileOption(
                      context,
                      'Tasks History',
                      Icons.history,
                      () {
                        // Navigate to tasks history page
                        Navigator.pushNamed(context, '/tasks-history');
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
                    LogOutButton(),
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Email: $email',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        SizedBox(height: 8),
        Text(
          'Role: $role',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'Completed Tasks: $completedTasks',
          style: TextStyle(fontSize: 16),
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
