import 'package:corporate_manager/Pages/taskpage/taskdetail.dart';
import 'package:corporate_manager/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';


class PointsPage extends StatelessWidget {
  final QuerySnapshot completedTasksSnapshot;

  PointsPage({required this.completedTasksSnapshot});

  @override
  Widget build(BuildContext context) {
    // Extract tasks as `Task` objects
    final List<Task> completedTasks = completedTasksSnapshot.docs
        .map((doc) => Task.fromDocument(doc))
        .toList();

    // Calculate total points
    int totalPoints = completedTasks.fold(
      0,
      (sum, task) => (sum + task.points).toInt(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Points",
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Colors.brown[800]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Points Display
            ListTile(
              title: Text(
                'Total Points',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                totalPoints.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HexColor("0b1623"),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Points Breakdown List
            Expanded(
              child: ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  final task = completedTasks[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailPage(task: task),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: Text(
                          '+${task.points}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: HexColor("0b1623"),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
