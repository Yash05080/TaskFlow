import 'package:corporate_manager/Pages/freelancing%20board/functions/timeformatter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postMessage;
  final String postUser;
  final String postRole;
  final Timestamp postTimestamp;

  const Comments({
    Key? key,
    required this.postId,
    required this.postMessage,
    required this.postUser,
    required this.postRole,
    required this.postTimestamp,
  }) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  void addComment() async {
    if (commentController.text.isNotEmpty) {
      CollectionReference commentsRef = FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .collection('Comments');

      await commentsRef.add({
        'user': currentUser.email,
        'comment': commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .update({'CommentCount': FieldValue.increment(1)});

      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
              ),
              // Display post details
              ListTile(
                title: Text(widget.postMessage),
                subtitle: Text('${widget.postUser} - ${widget.postRole}'),
                trailing: Text(
                  formatTimestamp(widget.postTimestamp),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Divider(),
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
                      return const Center(child: CircularProgressIndicator());
                    }

                    final comments = snapshot.data!.docs;

                    if (comments.isEmpty) {
                      return Center(
                        child: Text(
                          "No comments yet",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var commentData = comments[index];
                        return ListTile(
                          title: Text(commentData['user']),
                          subtitle: Text(commentData['comment']),
                          trailing: Text(
                            commentData['timestamp'] != null
                                ? formatTimestamp(commentData['timestamp'])
                                : 'Just now',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          style: const TextStyle(color: Colors.brown),
                          cursorColor: Colors.brown,
                          decoration: InputDecoration(
                            hintText: "Add a comment",
                            hintStyle:
                                const TextStyle(fontSize: 16, color: Colors.brown),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.brown, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 101, 67, 33), width: 1.5),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
