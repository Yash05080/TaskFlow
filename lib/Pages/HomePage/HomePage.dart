import 'package:corporate_manager/Pages/HomePage/widgets/activityfeed.dart';
import 'package:corporate_manager/Pages/HomePage/widgets/statcard.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/Posts.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/comments.dart';
import 'package:corporate_manager/providors/freelancingpageprovider.dart';
import 'package:corporate_manager/providors/userprovider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  late Future<Map<String, dynamic>> statsFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  // Function to initialize page, fetch data only on login or refresh
  void _initializePage() {
    statsFuture = fetchStats();
  }

  Future<Map<String, dynamic>> fetchStats() async {
    // Replace with your Firebase logic
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.uid;

    final assignedTasks = await FirebaseFirestore.instance
        .collection('tasks')
        .where('assignee', isEqualTo: userId)
        .get();

    final completedTasks = await FirebaseFirestore.instance
        .collection('tasks')
        .where('assignee', isEqualTo: userId)
        .where('status', isEqualTo: 'Completed')
        .get();

    final totalPosts =
        await FirebaseFirestore.instance.collection('User Posts').get();

    return {
      'assignedTasks': assignedTasks.size,
      'completedTasks': completedTasks.size,
      'totalPosts': totalPosts.size,
    };
  }

  void _refreshStats() {
    setState(() {
      statsFuture = fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userRole = Provider.of<UserProvider>(context).userRole;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '$_userRole Dashboard',
          style: TextStyle(color: Colors.brown[800]),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.brown),
            onPressed: _refreshStats,
            tooltip: 'Refresh Dashboard',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Stats
            FutureBuilder<Map<String, dynamic>>(
              future: statsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final stats = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatCard(
                        title: 'Discussions',
                        count: stats['totalPosts'],
                        icon: Icons.post_add,
                        color: Colors.blueAccent,
                      ),
                      StatCard(
                        title: 'Tasks Assigned',
                        count: stats['assignedTasks'],
                        icon: Icons.assignment,
                        color: Colors.greenAccent,
                      ),
                      StatCard(
                        title: 'Completed Tasks',
                        count: stats['completedTasks'],
                        icon: Icons.done,
                        color: Colors.orangeAccent,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Recent Freelance Posts Section
            const Text(
              'Recent Freelance Posts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('User Posts')
                  .orderBy('TimeStamp', descending: true)
                  .limit(2)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading posts: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No posts available.'),
                  );
                }

                final posts = snapshot.data!.docs;

                return Column(
                  children: List.generate(
                    posts.length,
                    (index) {
                      final post = posts[index];
                      return GestureDetector(
                        onTap: () {
                          Provider.of<FreelanceBoardProvider>(context,
                                  listen: false)
                              .openBottomSheet(context, post);
                        },
                        child: PostSection(
                          message: post['Message'],
                          user: post['UserEmail'],
                          role: post['Role'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          commentCount: post['CommentCount'] ?? 0,
                          timestamp1: post['TimeStamp'],
                          postSnapshot: post,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Activity Feed Placeholder
            const Text(
              'Your Activity Feed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const ActivityFeedCard(
              activity: 'John commented on your post',
              time: '5 mins ago',
            ),
            const ActivityFeedCard(
              activity: 'Anna liked your post',
              time: '10 mins ago',
            ),
            const SizedBox(height: 20),

            // Performance Metrics Placeholder
            const Text(
              'Performance Metrics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            //PerformanceChart(),
          ],
        ),
      ),
    );
  }
}
