import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/Posts.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/comments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostHistory extends StatefulWidget {
  const PostHistory({super.key});

  @override
  State<PostHistory> createState() => _PostHistoryState();
}

class _PostHistoryState extends State<PostHistory> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  bool _isBottomSheetOpen = false;
  PersistentBottomSheetController? _bottomSheetController;

  @override
  void initState() {
    super.initState();
    initializeCommentCounts();
  }

  Future<void> initializeCommentCounts() async {
    QuerySnapshot postsSnapshot =
        await FirebaseFirestore.instance.collection("User Posts").get();

    for (var post in postsSnapshot.docs) {
      try {
        post.get('CommentCount');
      } catch (e) {
        await FirebaseFirestore.instance
            .collection("User Posts")
            .doc(post.id)
            .update({'CommentCount': 0});
      }
    }
  }

  void _openBottomSheet(BuildContext context, String postId) {
    if (_isBottomSheetOpen) {
      _bottomSheetController?.close();
    } else {
      _bottomSheetController = showBottomSheet(
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.8,
            minChildSize: 0.3,
            initialChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Comments(postId: postId);
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
          "My Post History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
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
                      .where('UserEmail', isEqualTo: currentUser.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userPosts = snapshot.data!.docs;
                      if (userPosts.isEmpty) {
                        return const Center(
                            child: Text("You have no posts yet."));
                      }
                      return ListView.builder(
                        itemCount: userPosts.length,
                        itemBuilder: (context, index) {
                          final post = userPosts[index];
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
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
