import 'package:corporate_manager/Pages/taskpage/taskservice.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:flutter/material.dart';

class UpdateTaskPage extends StatefulWidget {
  final Task task;

  UpdateTaskPage({required this.task});

  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final TaskService _taskService = TaskService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priorityController;
  late TextEditingController _pointsController;
  late TextEditingController _assigneeEmailController;
  late TextEditingController _statusController;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _priorityController = TextEditingController(text: widget.task.priority);
    _pointsController = TextEditingController(text: widget.task.points.toString());
    _assigneeEmailController = TextEditingController(); // Leave blank initially
    _statusController = TextEditingController(text: widget.task.status);
    _deadline = widget.task.deadline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Task')),
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
                    String? assigneeUserId = await _taskService.getUserIdByEmail(_assigneeEmailController.text);

                    if (assigneeUserId != null) {
                      Map<String, dynamic> taskData = {
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'priority': _priorityController.text,
                        'deadline': _deadline,
                        'points': int.parse(_pointsController.text),
                        'assignee': assigneeUserId,
                        'status': _statusController.text,
                        'createdBy': widget.task.createdBy,
                      };

                      await _taskService.updateTask(widget.task.id, taskData);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('User not found'),
                      ));
                    }
                  }
                },
                child: Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}