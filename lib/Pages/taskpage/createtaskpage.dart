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

  CreateTaskPage({super.key});

  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> _selectDeadline(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate, // No past dates allowed
      lastDate: DateTime(
          currentDate.year + 5), // Allow selecting up to 5 years in the future
    );

    if (selectedDate != null && selectedDate != _deadline) {
      _deadline = selectedDate;
    }
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
                      vertical: 15.0, horizontal: 10.0),
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
                      vertical: 15.0, horizontal: 10.0),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
                maxLines: 4, // Set maximum lines to 4
                minLines: 1, // It will expand between 1 to 4 lines
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
                      vertical: 15.0, horizontal: 10.0),
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
                      vertical: 15.0, horizontal: 10.0),
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
                      vertical: 15.0, horizontal: 10.0),
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
                      vertical: 15.0, horizontal: 10.0),
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
                          : 'Deadline: ${_deadline!.toLocal()}'
                              .split(' ')[0], // Only show the date part
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDeadline(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0), // Space between fields

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Ensure the deadline is set before creating the task
                    if (_deadline == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a deadline'),
                        ),
                      );
                      return;
                    }
                    String? userId = await getUserId();
                    String? assigneeUserId = await _taskService
                        .getUserIdByEmail(_assigneeEmailController.text);

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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User not found'),
                      ));
                    }
                  }
                },
                child: const Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
