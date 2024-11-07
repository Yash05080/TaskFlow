import 'package:corporate_manager/models/task_model.dart';
import 'package:corporate_manager/providors/taskstateprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'taskservice.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priorityController = TextEditingController();
  final _pointsController = TextEditingController();
  final _assigneeEmailController = TextEditingController();
  final _statusController = TextEditingController();
  DateTime? _deadline;

  // Date picker for selecting the deadline
  Future<void> _selectDeadline(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(currentDate.year + 5),
    );

    if (selectedDate != null && selectedDate != _deadline) {
      setState(() {
        _deadline = selectedDate;
      });
    }
  }

  // Format deadline date
  String _formatDeadline(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Text Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16.0), // Space between fields

              // Description Text Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
                maxLines: 4,
                minLines: 1,
              ),
              const SizedBox(height: 16.0), // Space between fields

              // Priority Text Field
              TextFormField(
                controller: _priorityController,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a priority' : null,
              ),
              const SizedBox(height: 16.0), // Space between fields

              // Points Text Field
              TextFormField(
                controller: _pointsController,
                decoration: InputDecoration(
                  labelText: 'Points',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter points' : null,
              ),
              const SizedBox(height: 16.0), // Space between fields

              // Assignee Email Text Field
              TextFormField(
                controller: _assigneeEmailController,
                decoration: InputDecoration(
                  labelText: 'Assignee Email ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter assignee email ID' : null,
              ),
              const SizedBox(height: 16.0), // Space between fields

              // Status Text Field
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter status' : null,
              ),
              const SizedBox(height: 16.0), // Space between fields

              // Date Picker for Deadline
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _deadline == null
                          ? 'Select Deadline'
                          : 'Deadline: ${_formatDeadline(_deadline!)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDeadline(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0), // Space before submit button

              Consumer<TaskState>(
                builder: (context, taskState, _) => ElevatedButton(
                  onPressed: taskState.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            String? userId = await taskState.getUserId();
                            String? assigneeUserId =
                                await TaskService().getUserIdByEmail(
                              _assigneeEmailController.text,
                            );

                            if (assigneeUserId != null &&
                                assigneeUserId.isNotEmpty) {
                              Task task = Task(
                                id: '', // Assuming the ID is auto-generated when the task is created
                                title: _titleController.text,
                                description: _descriptionController.text,
                                priority: _priorityController.text,
                                points: int.parse(_pointsController.text),
                                assignee:
                                    assigneeUserId, // Pass the fetched assignee ID
                                status: _statusController.text,
                                deadline:
                                    _deadline!, // Ensure this is a DateTime
                                createdBy:
                                    userId ?? '', // Handle if user ID is null
                              );

                              // Create the task
                              await taskState.createTask(task);

                              if (!taskState.isLoading) {
                                Navigator.pop(context);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Assignee not found'),
                                ),
                              );
                            }
                          }
                        },
                  child: taskState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Create Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
