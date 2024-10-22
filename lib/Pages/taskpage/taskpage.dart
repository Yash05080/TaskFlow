import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/taskpage/createtaskpage.dart';
import 'package:corporate_manager/Pages/taskpage/taskdetail.dart';
import 'package:corporate_manager/Pages/taskpage/taskservice.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskService _taskService = TaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc['role'];
    }
    return null;
  }

  String formatCountdown(Duration duration) {
    return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Panel')),
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
            return StreamBuilder<QuerySnapshot>(
              stream: _taskService.getAllTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No tasks found'));
                } else {
                  // Convert documents to Task objects
                  List<Task> tasks = snapshot.data!.docs
                      .map((doc) => Task.fromDocument(doc))
                      .toList();

                  // Sort tasks based on deadline and priority
                  tasks.sort((a, b) {
                    // Sort by deadline first
                    int deadlineComparison = a.deadline.compareTo(b.deadline);
                    if (deadlineComparison != 0) {
                      return deadlineComparison;
                    }
                    // If deadlines are the same, sort by priority
                    return a.priority.compareTo(
                        b.priority); // Assuming priority is an integer
                  });

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      Task task = tasks[index];
                      DateTime now = DateTime.now();
                      Duration remainingTime = task.deadline.difference(now);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TaskDetailPage(task: task)));
                          },
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            tileColor: HexColor("f1e0d0"),
                            iconColor: HexColor("0b1623"),
                            textColor: HexColor("0b1623"),
                            title: Text(
                              task.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text('Status: ${task.status}'),
                            trailing: Tooltip(
                              message:
                                  "Time left: ${formatCountdown(remainingTime)}",
                              textStyle: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              preferBelow: false,
                              child: const Icon(
                                Icons.info_outline,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: FutureBuilder<String?>(
        future: getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              (snapshot.data == "Admin" || snapshot.data == "Manager")) {
            return FloatingActionButton(
              heroTag: 'uniqueCreateTaskTag',
              onPressed: () {
                // Navigate to create task page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTaskPage()),
                );
              },
              child: const Icon(Icons.add),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
