import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/likebutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PostSection extends StatefulWidget {
  final String message;
  final String user;
  final String role;
  final String postId;
  final List<String> likes;

  const PostSection(
      {super.key,
      required this.message,
      required this.user,
      required this.role,
      required this.likes,
      required this.postId});

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
                children: [
                  //Like Button
                  Row(
                    children: [
                      //button
                      LikeButton(isLiked: isLiked, onTap: toggleLike),

                      SizedBox(width: 8,),

                      //like count
                      Text(widget.likes.length.toString())
                    ],
                  )

                  //Comment Button
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
