import 'package:corporate_manager/Pages/taskpage/taskservice.dart';
import 'package:corporate_manager/Pages/taskpage/updatetaskpage.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:corporate_manager/providors/userprovider.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  TaskDetailPage({super.key, required this.task});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  Duration remainingTime = const Duration();
  late Timer timer;
  final TaskService _taskService = TaskService();
  String? assigneeEmail;

  @override
  void initState() {
    super.initState();
    updateRemainingTime();
    fetchAssigneeEmail(); // Fetch assignee email
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateRemainingTime();
    });
  }

  // Fetch the email of the assignee based on userId
  void fetchAssigneeEmail() async {
    final email = await _taskService.getUserEmailById(widget.task.assignee);
    setState(() {
      assigneeEmail =
          email ?? "No email found"; // Fallback if email is not found
    });
  }

  void updateRemainingTime() {
    setState(() {
      remainingTime = widget.task.deadline.difference(DateTime.now());
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text(
            "Are you sure you want to delete this task before completion?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () async {
              await _taskService.deleteTask(widget.task.id);
              Navigator.pop(context);
              Navigator.pop(context); // Go back after deletion
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String formatCountdown(Duration duration) {
    return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
  }

  Color _getStatusColor(String status, bool isPast) {
    switch (status) {
      case 'Active' || 'active':
        return Colors.green;

      case 'Upcoming' || 'upcomming':
        return Colors.blue;
      case 'Halt':
        return Colors.red;
      case 'Past':
        return Colors.grey;
      case 'Completed':
        return const Color.fromARGB(255, 255, 209, 59);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = context.watch<UserProvider>().userRole;
    final bool isPast = widget.task.deadline.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteTask,
          ),
        ],
      ),
      floatingActionButton: userRole == "Admin" || userRole == "Manager"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateTaskPage(task: widget.task),
                  ),
                );
              },
              child: const Icon(Icons.edit, size: 34),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Description',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(widget.task.description),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Assigned to',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(assigneeEmail ?? 'Loading...'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Priority',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.task.priority,
                        style: TextStyle(
                          color: widget.task.priority == 'High'
                              ? Colors.red
                              : Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Points',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(widget.task.points.toString()),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Deadline',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${widget.task.deadline.day}/${widget.task.deadline.month}/${widget.task.deadline.year}',
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Status',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.task.status,
                        style: TextStyle(
                          color: _getStatusColor(widget.task.status, isPast),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Time Left',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        formatCountdown(remainingTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
