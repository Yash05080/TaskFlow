
import 'package:corporate_manager/providors/userprovider.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  

  

  @override
  Widget build(BuildContext context) {
    final _userRole = Provider.of<UserProvider>(context).userRole;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$_userRole Dashboard',
          style: TextStyle(color: Colors.brown[800]),
        ),
        //backgroundColor: Colors.brown[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Stats and Quick Links
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatCard(
                    title: 'Total Posts',
                    count: '12',
                    icon: Icons.post_add,
                    color: Colors.blueAccent,
                  ),
                  StatCard(
                    title: 'Tasks Assigned',
                    count: '4',
                    icon: Icons.assignment,
                    color: Colors.greenAccent,
                  ),
                  StatCard(
                    title: 'Completed Tasks',
                    count: '25',
                    icon: Icons.done,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Main Section: Freelance Feed (Recent Posts + Popular Posts)
            const Text(
              'Recent Freelance Posts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            PostCard(
              title: 'Build a Mobile App',
              description: 'Looking for a Flutter developer...',
              status: 'Active',
              likes: 32,
              comments: 12,
            ),
            PostCard(
              title: 'Website Redesign',
              description: 'Seeking a web designer...',
              status: 'Ongoing',
              likes: 45,
              comments: 25,
            ),
            const SizedBox(height: 20),

            // Side Panel: Notifications / Activity Feed
            const Text(
              'Your Activity Feed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ActivityFeedCard(
              activity: 'John commented on your post',
              time: '5 mins ago',
            ),
            ActivityFeedCard(
              activity: 'Anna liked your post',
              time: '10 mins ago',
            ),
            const SizedBox(height: 20),

            // Performance Tracker / Leaderboard
            const Text(
              'Performance Metrics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            PerformanceChart(),
          ],
        ),
      ),
    );
  }
}

// Reusable Stat Card widget
class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  StatCard(
      {required this.title,
      required this.count,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// Reusable Post Card widget
class PostCard extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final int likes;
  final int comments;

  PostCard(
      {required this.title,
      required this.description,
      required this.status,
      required this.likes,
      required this.comments});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status: $status', style: const TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    const Icon(Icons.thumb_up, size: 16),
                    const SizedBox(width: 4),
                    Text('$likes'),
                    const SizedBox(width: 16),
                    const Icon(Icons.comment, size: 16),
                    const SizedBox(width: 4),
                    Text('$comments'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Activity Feed Card
class ActivityFeedCard extends StatelessWidget {
  final String activity;
  final String time;

  ActivityFeedCard({required this.activity, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications, color: Colors.blue),
      title: Text(activity),
      subtitle: Text(time),
    );
  }
}

// Placeholder for a Performance Chart widget
class PerformanceChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: const Center(
        child: Text('Performance Chart Placeholder'),
      ),
    );
  }
}
