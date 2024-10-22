import 'package:corporate_manager/Pages/freelancing%20board/functions/fetchrole.dart';
import 'package:corporate_manager/Pages/taskpage/taskservice.dart';
import 'package:corporate_manager/Pages/taskpage/updatetaskpage.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TaskDetailPage extends StatefulWidget {
  final TaskService _taskService = TaskService();
  final Task task;

  TaskDetailPage({super.key, required this.task});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Duration remainingTime = const Duration();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    getUserRole();
    updateRemainingTime();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateRemainingTime();
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
        content: const Text("are you sure you want to delete this task before completion?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("CANCEL"),
          ),
          TextButton(
              onPressed: () async {
              await widget._taskService.deleteTask(widget.task.id);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
              child: const Text("DELETE",style: TextStyle(color: Colors.red),))
        ],
      ),
    );
  }
  
  String? _userRole;

  Future<void> getUserRole() async {
    UserService userService = UserService();
    String? role = await userService.fetchUserRole(); // Fetch the user role
    setState(() {
      _userRole = role; // Store it in the state to be used in the UI
    });
  }

  
  String formatCountdown(Duration duration) {
    return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title,style: const TextStyle(fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteTask,
          ),
        ],
      ),
      floatingActionButton: _userRole == "Admin" || _userRole == "Manager"
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FloatingActionButton(
                                        onPressed:() {
                                            // Navigate to update task page with task details
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateTaskPage(task: widget.task),
                                              ),
                                            );
                                          } ,
                                        child: const Icon(Icons.edit,size: 34,),
                                      ),],):null,
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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(widget.task.description),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Priority',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: widget.task.priority.toLowerCase() == 'high'
                            ? Colors.red
                            : (widget.task.priority.toLowerCase() == 'low'
                                ? Colors.blue
                                : Colors.black),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(widget.task.priority),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Points',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.task.points.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(widget.task.status),
                    ),
                  ),
                
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Deadline',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(widget.task.deadline),
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
