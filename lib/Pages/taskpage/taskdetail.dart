import 'package:corporate_manager/Pages/taskpage/taskservice.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:flutter/material.dart';


class TaskDetailPage extends StatelessWidget {
  final TaskService _taskService = TaskService();
  final Task task;

  TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _taskService.deleteTask(task.id);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task.description}'),
            Text('Priority: ${task.priority}'),
            Text('Points: ${task.points}'),
            Text('Status: ${task.status}'),
          ],
        ),
      ),
    );
  }
}
