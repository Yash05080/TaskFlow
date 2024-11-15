import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:corporate_manager/providors/freelancingpageprovider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/deletebutton.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/timeformatter.dart';

class PostSection extends StatelessWidget {
  final String message;
  final String user;
  final String role;
  final String postId;
  final List<String> likes;
  final int commentCount;
  final Timestamp timestamp1;
  final DocumentSnapshot postSnapshot;

  const PostSection({
    super.key,
    required this.message,
    required this.user,
    required this.role,
    required this.postId,
    required this.likes,
    required this.commentCount,
    required this.timestamp1,
    required this.postSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final isLiked = likes.contains(currentUser.email);
    final freelanceProvider =
        Provider.of<FreelanceBoardProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 101, 67, 33)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Profile Picture
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.brown),
                          borderRadius: BorderRadius.circular(25),
                          color: HexColor("F1E0D0"),
                        ),
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 72, 48, 24),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(role),
                        ],
                      ),
                    ],
                  ),
                  if (user == currentUser.email)
                    Deletebutton(onTap: () => _deletePost(context)),
                ],
              ),
              const SizedBox(height: 8.0),
              // Message section
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  message,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 10),
              // Post options: like, comment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Like Button
                      GestureDetector(
                        onTap: () {
                          freelanceProvider.toggleLike(postId, isLiked);
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        likes.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 15),
                      // Comment Button
                      GestureDetector(
                        onTap: () {
                          freelanceProvider.openBottomSheet(
                              context, postSnapshot);
                        },
                        child: Icon(
                          Icons.mode_comment_outlined,
                          color: Colors.grey[600],
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        commentCount.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Text(
                    formatTimestamp(timestamp1),
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: Colors.grey[700]),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deletePost(BuildContext context) async {
    final freelanceProvider =
        Provider.of<FreelanceBoardProvider>(context, listen: false);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        // Delete comments first
        final commentsSnapshot = await FirebaseFirestore.instance
            .collection('User Posts')
            .doc(postId)
            .collection('Comments')
            .get();

        for (var doc in commentsSnapshot.docs) {
          await FirebaseFirestore.instance
              .collection('User Posts')
              .doc(postId)
              .collection('Comments')
              .doc(doc.id)
              .delete();
        }

        // Delete the post
        await FirebaseFirestore.instance
            .collection('User Posts')
            .doc(postId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete post: $e')),
        );
      }
    }
  }
}
