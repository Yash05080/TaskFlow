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
      await _taskService.createTask(task );
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
}
