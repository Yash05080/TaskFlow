import 'dart:async';
import 'package:corporate_manager/Pages/taskpage/taskservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId;
  String? get userId => _userId;

  Timer? _taskUpdateTimer;

  // Fetch current user ID
  Future<void> fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    _userId = user?.uid;
    notifyListeners();
  }

  // Create Task
  Future<String?> createTask(Task task) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _taskService.createTask(task);
      _isLoading = false;
      notifyListeners();
      return 'Task created successfully';
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to create task';
    }
  }

  // Fetch assignee user ID
  Future<String?> getAssigneeUserId(String email) async {
    try {
      return await _taskService.getUserIdByEmail(email);
    } catch (e) {
      return null;
    }
  }

  Stream<List<Task>> get taskStream {
    return _firestore.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromDocument(doc)).toList();
    });
  }

  // Method to check if the task deadline has passed
  Future<void> checkAndUpdateTaskStatus() async {
    final now = DateTime.now();

    // Fetch all tasks
    var tasksSnapshot = await _firestore.collection('tasks').get();

    for (var doc in tasksSnapshot.docs) {
      Task task = Task.fromDocument(doc);
      if (task.deadline.isBefore(now) && task.status != 'past') {
        // If the deadline has passed, update status to 'past'
        await _firestore.collection('tasks').doc(doc.id).update({
          'status': 'past',
        });
      }
    }
  }

  // Start periodic task status check (runs every 1 minute)
  void startPeriodicTaskStatusCheck() {
    _taskUpdateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      checkAndUpdateTaskStatus();
    });
  }

  // Stop the periodic check if not needed
  void stopPeriodicTaskStatusCheck() {
    _taskUpdateTimer?.cancel();
  }

  @override
  void dispose() {
    // Ensure that the timer is cancelled when not needed anymore
    stopPeriodicTaskStatusCheck();
    super.dispose();
  }
}
