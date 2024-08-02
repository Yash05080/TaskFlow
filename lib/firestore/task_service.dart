/*import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a task
  Future<void> createTask(Map<String, dynamic> taskData) async {
    try {
      await _firestore.collection('tasks').add(taskData);
    } catch (e) {
      print(e);
    }
  }

  // Update a task
  Future<void> updateTask(String taskId, Map<String, dynamic> taskData) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update(taskData);
    } catch (e) {
      print(e);
    }
  }

  // Get tasks assigned to a user
  Stream<QuerySnapshot> getUserTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('assignee', isEqualTo: userId)
        .snapshots();
  }
}*/
