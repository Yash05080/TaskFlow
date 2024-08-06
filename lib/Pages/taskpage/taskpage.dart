import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/taskpage/createtaskpage.dart';
import 'package:corporate_manager/Pages/taskpage/taskservice.dart';
import 'package:corporate_manager/Pages/taskpage/updatetaskpage.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Panel')),
      body: FutureBuilder<String?>(
        future: getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User role not found'));
          } else {
            String role = snapshot.data!;
            return StreamBuilder<QuerySnapshot>(
              stream: _taskService.getAllTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No tasks found'));
                } else {
                  List<Task> tasks = snapshot.data!.docs
                      .map((doc) => Task.fromDocument(doc))
                      .toList();
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      Task task = tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text('Status: ${task.status}'),
                        trailing: role == "Admin" || role == "Manager"
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Navigate to update task page with task details
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateTaskPage(task: task),
                                        ),
                                      );
                                    },
                                  ),
                                  if (role == "Admin")
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        await _taskService.deleteTask(task.id);
                                      },
                                    ),
                                ],
                              )
                            : null,
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
              child: Icon(Icons.add),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
