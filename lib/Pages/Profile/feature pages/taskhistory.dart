import 'package:corporate_manager/Pages/taskpage/taskdetail.dart';
import 'package:corporate_manager/providors/taskprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:hexcolor/hexcolor.dart';

class TaskHistoryPage extends StatelessWidget {
  const TaskHistoryPage({super.key});

  String formatCountdown(Duration duration) {
    return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task History',
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
            return const Center(child: Text('No completed or past tasks found'));
          } else {
            // Filter tasks for "Past" or "Completed" status or deadline has passed
            List<Task> historyTasks = snapshot.data!.where((task) {
              bool deadlinePassed = task.deadline.isBefore(DateTime.now());
              return deadlinePassed ||
                  task.status.toLowerCase() == 'past' ||
                  task.status.toLowerCase() == 'completed';
            }).toList();

            if (historyTasks.isEmpty) {
              return const Center(
                  child: Text('No completed or past tasks found'));
            }

            // Sort tasks by deadline
            historyTasks.sort((a, b) => a.deadline.compareTo(b.deadline));

            return ListView.builder(
              itemCount: historyTasks.length,
              itemBuilder: (context, index) {
                Task task = historyTasks[index];

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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      tileColor: HexColor("f1e0d0"),
                      iconColor: HexColor("0b1623"),
                      textColor: HexColor("0b1623"),
                      title: Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        'Status: ${task.status}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Subtle text color for history
                        ),
                      ),
                      trailing: Text(
                        'Deadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
