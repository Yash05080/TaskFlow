// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to get user ID by email
  Future<String?> getUserIdByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Fetch current user ID (make sure it's implemented)
  Future<String?> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Method to create a new task
  Future<void> createTask(Task task) async {
    try {
      await _firestore.collection('tasks').add(task.toMap());
    } catch (e) {
      print(e);
    }
  }

  // Method to update an existing task
  Future<void> updateTask(String taskId, Map<String, dynamic> taskData) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update(taskData);
    } catch (e) {
      print(e);
    }
  }

  // Method to delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print(e);
    }
  }

  // Method to get a stream of tasks for real-time updates
  Stream<QuerySnapshot> getAllTasks() {
    return _firestore.collection('tasks').snapshots();
  }
}
