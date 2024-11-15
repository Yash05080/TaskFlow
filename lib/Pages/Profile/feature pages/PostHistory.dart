import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/Posts.dart';

import 'package:corporate_manager/Pages/freelancing%20board/widgets/comments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:corporate_manager/providors/freelancingpageprovider.dart';

class PostHistory extends StatelessWidget {
  const PostHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final freelanceProvider = Provider.of<FreelanceBoardProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Post History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            // Allow closing the bottom sheet via gesture
            if (freelanceProvider.isBottomSheetOpen && details.delta.dy > 0) {
              freelanceProvider.closeBottomSheet();
            }
          },
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .where('UserEmail', isEqualTo: currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final userPosts = snapshot.data?.docs ?? [];

              if (userPosts.isEmpty) {
                return const Center(child: Text("You have no posts yet."));
              }

              return ListView.builder(
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  final post = userPosts[index];
                  return GestureDetector(
                    onTap: () {
                      freelanceProvider.openBottomSheet(context, post);
                    },
                    child: PostSection(
                      message: post['Message'],
                      user: post['UserEmail'],
                      role: post['Role'],
                      postId: post.id,
                      likes: List<String>.from(post['Likes'] ?? []),
                      commentCount: post['CommentCount'] ?? 0,
                      timestamp1: post['TimeStamp'],
                      postSnapshot: post, // Pass the entire DocumentSnapshot
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
