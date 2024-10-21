import 'package:flutter/material.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard',style: TextStyle(color: Colors.brown[800]),),
        //backgroundColor: Colors.brown[700],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
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
                    count: '7',
                    icon: Icons.assignment,
                    color: Colors.greenAccent,
                  ),
                  StatCard(
                    title: 'Completed Tasks',
                    count: '5',
                    icon: Icons.done,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Main Section: Freelance Feed (Recent Posts + Popular Posts)
            Text(
              'Recent Freelance Posts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 20),

            // Side Panel: Notifications / Activity Feed
            Text(
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
            SizedBox(height: 20),

            // Performance Tracker / Leaderboard
            Text(
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
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
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status: $status', style: TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    Icon(Icons.thumb_up, size: 16),
                    SizedBox(width: 4),
                    Text('$likes'),
                    SizedBox(width: 16),
                    Icon(Icons.comment, size: 16),
                    SizedBox(width: 4),
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
      leading: Icon(Icons.notifications, color: Colors.blue),
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
      child: Center(
        child: Text('Performance Chart Placeholder'),
      ),
    );
  }
}
