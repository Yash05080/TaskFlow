import 'package:corporate_manager/Pages/taskpage/taskdetail.dart';
import 'package:corporate_manager/providors/taskprovider.dart';
import 'package:corporate_manager/providors/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:corporate_manager/Pages/taskpage/createtaskpage.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:hexcolor/hexcolor.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TaskProvider _taskProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access provider here instead of in initState()
    _taskProvider = Provider.of<TaskProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    // The periodic task status check will be started in didChangeDependencies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskProvider.startPeriodicTaskStatusCheck();
    });
  }

  @override
  void dispose() {
    // Stop the periodic task status check when widget is disposed
    _taskProvider.stopPeriodicTaskStatusCheck();
    super.dispose();
  }

  String formatCountdown(Duration duration) {
    return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
  }

  /// Function to get the appropriate color for a task priority
  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.blue; // Default color for unknown priorities
    }
  }

  /// Function to get the appropriate color for a task status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'upcoming':
        return Colors.blue;
      case 'halt':
        return Colors.red;
      default:
        return Colors.black; // Default color for other statuses
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<Task>>(
        stream: taskProvider.taskStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found'));
          } else {
            // Filter tasks for active tasks (tasks that are yet to pass the deadline)
            List<Task> activeTasks = snapshot.data!.where((task) {
              bool deadlineNotPassed = task.deadline.isAfter(DateTime.now());
              bool statusIsActive = task.status.toLowerCase() != 'past' &&
                  task.status.toLowerCase() != 'completed';
              return deadlineNotPassed && statusIsActive;
            }).toList();

            if (activeTasks.isEmpty) {
              return const Center(child: Text('No active tasks found'));
            }

            // Sort tasks by deadline, and then priority
            activeTasks.sort((a, b) {
              int deadlineComparison = a.deadline.compareTo(b.deadline);
              return deadlineComparison != 0
                  ? deadlineComparison
                  : a.priority.compareTo(b.priority);
            });

            return ListView.builder(
              itemCount: activeTasks.length,
              itemBuilder: (context, index) {
                Task task = activeTasks[index];
                DateTime now = DateTime.now();
                Duration remainingTime = task.deadline.difference(now);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailPage(task: task),
                        ),
                      );
                    },
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      tileColor: HexColor("f1e0d0"),
                      iconColor: HexColor("0b1623"),
                      textColor: HexColor("0b1623"),
                      title: Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          children: [
                            // Status part
                            const TextSpan(
                              text: 'Status: [',
                              style: TextStyle(
                                color: Colors
                                    .black, // Default color for the "Status" label
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: task.status, // Status text
                              style: TextStyle(
                                color: getStatusColor(
                                    task.status), // Color based on task status
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: ', ',
                              style: TextStyle(
                                color: Colors
                                    .black, // Default color for the "Status" label
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Priority part
                            TextSpan(
                              text: task.priority, // Priority text
                              style: TextStyle(
                                color: getPriorityColor(task
                                    .priority), // Color based on task priority
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: ']',
                              style: TextStyle(
                                color: Colors
                                    .black, // Default color for the "Status" label
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Tooltip(
                        message: "Time left: ${formatCountdown(remainingTime)}",
                        textStyle: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        preferBelow: false,
                        child: const Icon(
                          Icons.info_outline,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: (userProvider.userRole == "Admin" ||
              userProvider.userRole == "Manager")
          ? FloatingActionButton(
              heroTag: 'uniqueCreateTaskTag',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateTaskPage()),
                );
              },
              child: const Icon(Icons.add),
            )
          : Container(),
    );
  }
}
