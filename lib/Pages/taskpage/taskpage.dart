import 'package:corporate_manager/providors/taskprovider.dart';
import 'package:corporate_manager/providors/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:corporate_manager/Pages/taskpage/createtaskpage.dart';
import 'package:corporate_manager/Pages/taskpage/taskdetail.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  String formatCountdown(Duration duration) {
    return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<Task>>(
        stream: taskProvider.taskStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found'));
          } else {
            List<Task> tasks = snapshot.data!;

            tasks.sort((a, b) {
              int deadlineComparison = a.deadline.compareTo(b.deadline);
              return deadlineComparison != 0
                  ? deadlineComparison
                  : a.priority.compareTo(b.priority);
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
                          builder: (context) => TaskDetailPage(task: task),
                        ),
                      );
                    },
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: HexColor("f1e0d0"),
                      iconColor: HexColor("0b1623"),
                      textColor: HexColor("0b1623"),
                      title: Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text('Status: ${task.status}'),
                      trailing: Tooltip(
                        message:
                            "Time left: ${formatCountdown(remainingTime)}",
                        textStyle: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
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
      ),
      floatingActionButton: (userProvider.userRole == "Admin" ||
              userProvider.userRole == "Manager")
          ? FloatingActionButton(
              heroTag: 'uniqueCreateTaskTag',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTaskPage()),
                );
              },
              child: const Icon(Icons.add),
            )
          : Container(),
    );
  }
}
