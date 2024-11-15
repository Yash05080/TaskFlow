import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/timeformatter.dart';

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
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isExpanded = false;

  static const int maxLengthForReadMore = 150;
  static const int maxLengthForScroll = 500;

  void _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    await _firestore
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      'UserEmail': currentUser.email,
      'Message': _commentController.text.trim(),
      'Role': widget.postRole,
      'TimeStamp': Timestamp.now(),
    });

    // Update the CommentCount in the post document
    await _firestore.collection("User Posts").doc(widget.postId).update({
      'CommentCount': FieldValue.increment(1),
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Post message and details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isLongMessage =
                            widget.postMessage.length > maxLengthForReadMore;
                        final isScrollableMessage =
                            widget.postMessage.length > maxLengthForScroll;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display message with scroll functionality if too long
                            if (isScrollableMessage)
                              Container(
                                height: 100,
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.postMessage,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Text(
                                widget.postMessage,
                                maxLines:
                                    isExpanded || !isLongMessage ? null : 3,
                                overflow: isExpanded || !isLongMessage
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                            // "Read More" or "Read Less" option for non-scrollable messages
                            if (!isScrollableMessage && isLongMessage)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Text(
                                  isExpanded ? "Read less" : "Read more",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Posted by: ${widget.postUser} (${widget.postRole})",
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Posted on: ${widget.postTimestamp.toDate()}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Comments Stream
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("User Posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .orderBy("TimeStamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No comments yet."));
                    }

                    final comments = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          title: Text(comment['UserEmail']),
                          subtitle: Text(comment['Message']),
                          trailing: Text(
                            comment['TimeStamp'] != null
                                ? formatTimestamp(comment['TimeStamp'])
                                : 'Just now',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Add Comment Input
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: "Add a comment...",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _addComment,
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
