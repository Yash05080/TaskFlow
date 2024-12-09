import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/models/task_model.dart';

class PerformanceMatrix extends StatelessWidget {
  final int assignedTasks;
  final int completedTasks;
  final int pastTasks;
  final String userId;

  const PerformanceMatrix({
    required this.assignedTasks,
    required this.completedTasks,
    required this.pastTasks,
    required this.userId,
    super.key,
  });

  Future<int> fetchAndCalculateTotalPoints() async {
    // Fetch completed tasks from Firestore
    final QuerySnapshot completedTasksSnapshot = await FirebaseFirestore
        .instance
        .collection('tasks')
        .where('status', isEqualTo: 'Completed')
        .where('assignee', isEqualTo: userId)
        .get();

    // Convert documents to Task objects
    final List<Task> completedTasks = completedTasksSnapshot.docs
        .map((doc) => Task.fromDocument(doc))
        .toList();

    // Calculate total points
    int totalPoints = 0;
    for (var task in completedTasks) {
      totalPoints += task.points;
    }

    return totalPoints;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the completion percentage
    int totalTasks = completedTasks + pastTasks;
    double completionPercentage =
        totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;

    return FutureBuilder<int>(
      future: fetchAndCalculateTotalPoints(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final int totalPoints = snapshot.data ?? 0;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Performance Metrics",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Grid layout for four stats
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatItem(
                      title: "Total Points",
                      value: totalPoints.toString(),
                      color: Colors.blueAccent,
                    ),
                    _buildStatItem(
                      title: "Tasks Assigned",
                      value: assignedTasks.toString(),
                      color: Colors.redAccent,
                    ),
                    _buildStatItem(
                      title: "Completed Tasks",
                      value: completedTasks.toString(),
                      color: Colors.greenAccent,
                    ),
                    _buildStatItem(
                      title: "Past Tasks",
                      value: pastTasks.toString(),
                      color: Colors.orangeAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Completion rate at the center
                Column(
                  children: [
                    const Text(
                      "Completion Rate",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${completionPercentage.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
