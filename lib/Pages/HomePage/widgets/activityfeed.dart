import 'package:flutter/material.dart';

class ActivityFeedCard extends StatelessWidget {
  final String activity;
  final String time;
  final IconData icon;

  const ActivityFeedCard({
    Key? key,
    required this.activity,
    required this.time,
    this.icon = Icons.notifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(activity),
      subtitle: Text(time),
    );
  }
}
