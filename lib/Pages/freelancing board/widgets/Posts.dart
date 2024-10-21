import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/deletebutton.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/likebutton.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/timeformatter.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/comments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PostSection extends StatefulWidget {
  final String message;
  final String user;
  final String role;
  final String postId;
  final List<String> likes;
  final int commentCount; // Add this line
  final Timestamp timestamp1;

  const PostSection({
    super.key,
    required this.message,
    required this.user,
    required this.role,
    required this.likes,
    required this.postId,
    required this.commentCount,
    required this.timestamp1,
  });

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState

    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //fetch the document reference
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // Delete post

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Post"),
        content: Text("are you sure you want to delete this post?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("CANCEL"),
          ),
          TextButton(
              onPressed: () async {
                //delete the comments from firestore first
                final commentDocs = await FirebaseFirestore.instance
                    .collection('User Posts')
                    .doc(widget.postId)
                    .collection('Comments')
                    .get();

                for (var doc in commentDocs.docs) {
                  await FirebaseFirestore.instance
                      .collection('User Posts')
                      .doc(widget.postId)
                      .collection('Comments')
                      .doc(doc.id)
                      .delete();
                }

                //then delete the post
                FirebaseFirestore.instance
                    .collection('User Posts')
                    .doc(widget.postId)
                    .delete()
                    .then((value) => print("post deleted"))
                    .catchError(
                        (error) => print("failed to delete the post: $error"));

                // dismiss the dialog box
                Navigator.pop(context);
              },
              child: Text("DELETE",style: TextStyle(color: Colors.red),))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 101, 67, 33),
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
              8.0), // Add padding around the whole container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      //Profile Picture
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.brown),
                          borderRadius: BorderRadius.circular(25),
                          color: HexColor("F1E0D0"),
                        ),
                        child: Icon(Icons.person),
                      ),

                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 72, 48, 24),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget.role),
                        ],
                      ),
                    ],
                  ),
                  if (widget.user == currentUser.email)
                    Deletebutton(onTap: deletePost),
                ],
              ),
              const SizedBox(height: 8.0), // Add space between user and message
              // Message section
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.message,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              //post options: like, comment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      //Like Button
                      Row(
                        children: [
                          //button
                          LikeButton(isLiked: isLiked, onTap: toggleLike),

                          SizedBox(
                            width: 6,
                          ),

                          //like count
                          Text(
                            widget.likes.length.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey[700]),
                          )
                        ],
                      ),

                      SizedBox(
                        width: 15,
                      ),

                      //Comment Button
                      GestureDetector(
                          onTap: () {
                            showBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: DraggableScrollableSheet(
                                    maxChildSize: 0.5,
                                    initialChildSize: 0.5,
                                    minChildSize: 0.2,
                                    builder: (context, ScrollController) {
                                      return Comments(
                                          postId:
                                              widget.postId); // Pass the postId
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.mode_comment_outlined,
                            color: Colors.grey[600],
                            size: 28,
                          )),

                      SizedBox(
                        width: 6,
                      ),

                      //comment count
                      Text(
                        widget.commentCount.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Text(
                    formatTimestamp(widget.timestamp1),
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
}
