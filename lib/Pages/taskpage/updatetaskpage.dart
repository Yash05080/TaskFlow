// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:corporate_manager/Pages/taskpage/taskservice.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:flutter/material.dart';

class UpdateTaskPage extends StatefulWidget {
  final Task task;

  const UpdateTaskPage({super.key, required this.task});

  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final TaskService _taskService = TaskService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _pointsController;
  late TextEditingController _assigneeEmailController;
  DateTime? _deadline;

  // Dropdown selections
  String? _selectedPriority;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _pointsController =
        TextEditingController(text: widget.task.points.toString());
    _assigneeEmailController = TextEditingController(); // Initially empty

    // Correctly initialize dropdown values
    _selectedPriority = _validateDropdownValue(
      widget.task.priority,
      ['High', 'Medium', 'Low'],
    );
    _selectedStatus = _validateDropdownValue(
      widget.task.status,
      ['Active', 'Upcoming', 'Halt', 'Past', 'Completed'],
    );

    _deadline = widget.task.deadline;

    fetchAssigneeEmail();
  }

  String? _validateDropdownValue(String? currentValue, List<String> options) {
    return options.contains(currentValue) ? currentValue : null;
  }

  void fetchAssigneeEmail() async {
    String? email = await _taskService.getUserEmailById(widget.task.assignee);
    setState(() {
      _assigneeEmailController.text = email ?? 'No email found';
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    _assigneeEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
                maxLines: 4,
                minLines: 1,
              ),
              const SizedBox(height: 16.0),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem<String>(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a priority' : null,
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _pointsController,
                decoration: const InputDecoration(labelText: 'Points'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter points' : null,
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _assigneeEmailController,
                decoration:
                    const InputDecoration(labelText: 'Assignee Email ID'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter assignee email ID' : null,
              ),
              const SizedBox(height: 16.0),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  {'label': 'Active', 'color': Colors.green},
                  {'label': 'Upcoming', 'color': Colors.blue},
                  {'label': 'Halt', 'color': Colors.red},
                  {
                    'label': 'Completed',
                    'color': const Color.fromARGB(255, 215, 162, 0)
                  },
                ]
                    .map((status) => DropdownMenuItem<String>(
                          value: status['label'] as String,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: status['color'] as Color,
                              ),
                              const SizedBox(width: 8),
                              Text(status['label'] as String),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a status' : null,
              ),
              const SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? assigneeUserId = await _taskService
                        .getUserIdByEmail(_assigneeEmailController.text);

                    if (assigneeUserId != null) {
                      Map<String, dynamic> taskData = {
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'priority': _selectedPriority,
                        'deadline': _deadline,
                        'points': int.parse(_pointsController.text),
                        'assignee': assigneeUserId,
                        'status': _selectedStatus,
                        'createdBy': widget.task.createdBy,
                      };

                      await _taskService.updateTask(widget.task.id, taskData);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User not found'),
                      ));
                    }
                  }
                },
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
