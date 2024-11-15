import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class PostSection extends StatelessWidget {
  final String message;
  final String user;
  final String role;
  final String postId;
  final List<String> likes;
  final int commentCount;
  final Timestamp timestamp1;

  const PostSection({
    super.key,
    required this.message,
    required this.user,
    required this.role,
    required this.postId,
    required this.likes,
    required this.commentCount,
    required this.timestamp1,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final isLiked = likes.contains(currentUser.email);

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
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: HexColor("F1E0D0"),
                    radius: 25,
                    child: const Icon(Icons.person, color: Colors.brown),
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
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  message,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Call toggle like function here
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                  //const SizedBox(width: 6),
                  Text(
                    likes.length.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      // Open comments
                    },
                    icon: Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.grey[600],
                    ),
                  ),
                  //const SizedBox(width: 6),
                  Text(
                    commentCount.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
