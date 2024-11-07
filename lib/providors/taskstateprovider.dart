import 'package:corporate_manager/Pages/taskpage/taskservice.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskState extends ChangeNotifier {
  TaskService _taskService = TaskService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Create Task
  Future<void> createTask(Task task) async {
    _isLoading = true;
    notifyListeners();

    await _taskService.createTask(task);

    _isLoading = false;
    notifyListeners();
  }

  // Fetch current user ID
  Future<String?> getUserId() async {
    return await _taskService.getCurrentUserId();
  }
}

