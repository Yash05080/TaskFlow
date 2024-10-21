import 'package:corporate_manager/Pages/freelancing%20board/functions/timeformatter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comments extends StatefulWidget {
  final String postId;

  const Comments({super.key, required this.postId});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Initialize comment counts for existing posts
  Future<void> initializeCommentCounts() async {
    // Get all documents from the "User Posts" collection
    QuerySnapshot postsSnapshot =
        await FirebaseFirestore.instance.collection("User Posts").get();

    for (var post in postsSnapshot.docs) {
      // Check if CommentCount exists; if not, initialize it
      try {
        // Access CommentCount, will throw if it doesn't exist
        await post.get('CommentCount');
      } catch (e) {
        // If it doesn't exist, set it to 0
        await FirebaseFirestore.instance
            .collection("User Posts")
            .doc(post.id)
            .set({'CommentCount': 0}, SetOptions(merge: true));
      }
    }
  }

  // Function to add a comment to the Firestore subcollection and update CommentCount
  void addComment() async {
    if (commentController.text.isNotEmpty) {
      CollectionReference commentsRef = FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .collection('Comments');

      // Add the comment
      await commentsRef.add({
        'user': currentUser.email,
        'comment': commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the CommentCount for the post
      await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .set({
        'CommentCount': FieldValue.increment(1), // Increment by 1
      }, SetOptions(merge: true));

      commentController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeCommentCounts(); // Initialize comment counts on start
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      minChildSize: 0.3,
      initialChildSize: 0.7,
      builder: (BuildContext context, ScrollController scrollController) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Top handle to indicate drag functionality
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
                  ),

                  // Comment Stream (Existing comments)
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('User Posts')
                          .doc(widget.postId)
                          .collection('Comments')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final comments = snapshot.data!.docs;

                        // Check if there are no comments
                        if (comments.isEmpty) {
                          return Center(
                            child: Text(
                              "No comments yet",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            var commentData = comments[index];
                            return ListTile(
                              title: Text(commentData['user']),
                              subtitle: Text(commentData['comment']),
                              trailing: Text(
                                commentData['timestamp'] != null
                                    ? (formatTimestamp(
                                        commentData['timestamp']))
                                    : 'Just now',
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Comment input field
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 101, 67, 33),
                              ),
                              cursorColor: Colors.brown,
                              decoration: InputDecoration(
                                hintText: "Add a comment",
                                hintStyle: const TextStyle(
                                    fontSize: 16, color: Colors.brown),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.brown, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 101, 67, 33),
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: addComment,
                            icon: const Icon(
                              Icons.send_sharp,
                              size: 30,
                              color: Colors.brown,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
