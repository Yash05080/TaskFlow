import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/Posts.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/fetchrole.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/comments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Freelancingboard extends StatefulWidget {
  const Freelancingboard({super.key});

  @override
  State<Freelancingboard> createState() => _FreelancingboardState();
}

class _FreelancingboardState extends State<Freelancingboard> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  String _userRole = "Employee";
  bool _isBottomSheetOpen = false;
  PersistentBottomSheetController? _bottomSheetController;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    initializeCommentCounts();
  }

  Future<void> initializeCommentCounts() async {
    // Get all documents from the "User Posts" collection
    QuerySnapshot postsSnapshot =
        await FirebaseFirestore.instance.collection("User Posts").get();

    for (var post in postsSnapshot.docs) {
      // Try to access CommentCount, if it throws an error, we add it
      try {
        // If CommentCount exists, do nothing
        post.get('CommentCount');
      } catch (e) {
        // If accessing the field throws an error, it means it doesn't exist
        await FirebaseFirestore.instance
            .collection("User Posts")
            .doc(post.id)
            .update({'CommentCount': 0});
      }
    }
  }

  Future<void> _fetchUserRole() async {
    UserService userService = UserService();
    String? role = await userService.fetchUserRole();

    if (role != null) {
      setState(() {
        _userRole = role;
      });
    }
  }

  void PostMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'Role': _userRole,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'CommentCount': 0, // Initialize CommentCount to 0
      });
      setState(() {
        textController.clear();
      });
    }
  }

  // Open the draggable comments section (bottom sheet)
  void _openBottomSheet(BuildContext context, String postId) {
    if (_isBottomSheetOpen) {
      _bottomSheetController?.close(); // Close if already open
    } else {
      _bottomSheetController = showBottomSheet(
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.8,
            minChildSize: 0.3,
            initialChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Comments(
                  postId: postId); // This should be your comments widget
            },
          );
        },
      );
      setState(() {
        _isBottomSheetOpen = true;
      });

      _bottomSheetController?.closed.then((value) {
        setState(() {
          _isBottomSheetOpen = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collab Space",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          // Close the comments section when scrolling outside the bottom sheet
          onPanUpdate: (details) {
            if (_isBottomSheetOpen && details.delta.dy > 0) {
              _bottomSheetController?.close();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .orderBy("TimeStamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              _openBottomSheet(context, post.id);
                            },
                            child: PostSection(
                              message: post['Message'],
                              user: post['UserEmail'],
                              role: post['Role'],
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                              commentCount: post['CommentCount'] ?? 0,
                              timestamp1: post['TimeStamp'],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text("no post yet"));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),

              // Post textfield
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(
                            controller: textController,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 101, 67, 33),
                            ),
                            cursorColor: Colors.brown,
                            decoration: InputDecoration(
                                labelText: "Post Something",
                                labelStyle: const TextStyle(
                                    fontSize: 16, color: Colors.brown),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.brown, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                floatingLabelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 101, 67, 33),
                                    fontSize: 18),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 101, 67, 33),
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          PostMessage();
                        },
                        icon: const Icon(
                          Icons.send_sharp,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
