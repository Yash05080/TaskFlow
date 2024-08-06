import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  String priority;
  DateTime deadline;
  int points;
  String assignee;
  String status;
  String createdBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.points,
    required this.assignee,
    required this.status,
    required this.createdBy,
  });

  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
      priority: doc['priority'],
      deadline: (doc['deadline'] as Timestamp).toDate(),
      points: doc['points'],
      assignee: doc['assignee'],
      status: doc['status'],
      createdBy: doc['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'deadline': deadline,
      'points': points,
      'assignee': assignee,
      'status': status,
      'createdBy': createdBy,
    };
  }
}
