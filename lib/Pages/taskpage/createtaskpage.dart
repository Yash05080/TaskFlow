import 'package:corporate_manager/models/task_model.dart';
import 'package:flutter/material.dart';

import 'taskservice.dart';
import 'package:firebase_auth/firebase_auth.dart';



class CreateTaskPage extends StatelessWidget {
  final TaskService _taskService = TaskService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priorityController = TextEditingController();
  final _pointsController = TextEditingController();
  final _assigneeEmailController = TextEditingController();
  final _statusController = TextEditingController();
  DateTime? _deadline;

  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                controller: _priorityController,
                decoration: InputDecoration(labelText: 'Priority'),
                validator: (value) => value!.isEmpty ? 'Please enter a priority' : null,
              ),
              TextFormField(
                controller: _pointsController,
                decoration: InputDecoration(labelText: 'Points'),
                validator: (value) => value!.isEmpty ? 'Please enter points' : null,
              ),
              TextFormField(
                controller: _assigneeEmailController,
                decoration: InputDecoration(labelText: 'Assignee Email ID'),
                validator: (value) => value!.isEmpty ? 'Please enter assignee email ID' : null,
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) => value!.isEmpty ? 'Please enter status' : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _deadline = DateTime.now().add(Duration(days: 7)); // Set deadline to one week from now
                    String? userId = await getUserId();
                    String? assigneeUserId = await _taskService.getUserIdByEmail(_assigneeEmailController.text);

                    if (assigneeUserId != null) {
                      Task task = Task(
                        id: '',
                        title: _titleController.text,
                        description: _descriptionController.text,
                        priority: _priorityController.text,
                        deadline: _deadline!,
                        points: int.parse(_pointsController.text),
                        assignee: assigneeUserId,
                        status: _statusController.text,
                        createdBy: userId!,
                      );

                      await _taskService.createTask(task.toMap());
                      Navigator.pop(context);
                    } else {
                      // Handle the case where the user is not found
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('User not found'),
                      ));
                    }
                  }
                },
                child: Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

