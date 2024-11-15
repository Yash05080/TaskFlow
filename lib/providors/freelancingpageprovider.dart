import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/comments.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FreelanceBoardProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _userRole = "Employee";
  String get userRole => _userRole;

  bool _isBottomSheetOpen = false;
  bool get isBottomSheetOpen => _isBottomSheetOpen;

  PersistentBottomSheetController? _bottomSheetController;

  final TextEditingController textController = TextEditingController();

  FreelanceBoardProvider() {
    _fetchUserRole();
    initializeCommentCounts();
  }

  Future<void> initializeCommentCounts() async {
    QuerySnapshot postsSnapshot =
        await _firestore.collection("User Posts").get();

    for (var post in postsSnapshot.docs) {
      final postData = post.data() as Map<String, dynamic>?; // Cast to Map
      if (postData != null && !postData.containsKey('CommentCount')) {
        await _firestore
            .collection("User Posts")
            .doc(post.id)
            .update({'CommentCount': 0});
      }
    }
    notifyListeners();
  }

  Future<void> _fetchUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection("users").doc(user.uid).get();
      if (snapshot.exists) {
        _userRole = snapshot["role"] ?? "Employee";
      }
      notifyListeners();
    }
  }

  Future<void> postMessage() async {
    if (textController.text.trim().isEmpty) return;

    final currentUser = _auth.currentUser!;
    await _firestore.collection("User Posts").add({
      'UserEmail': currentUser.email,
      'Message': textController.text.trim(),
      'Role': _userRole,
      'TimeStamp': Timestamp.now(),
      'Likes': [],
      'CommentCount': 0,
    });
    textController.clear();
    notifyListeners();
  }

  void openBottomSheet(BuildContext context, DocumentSnapshot post) {
    if (_isBottomSheetOpen) {
      closeBottomSheet();
    } else {
      _bottomSheetController = showBottomSheet(
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1.0,
            minChildSize: 0.8,
            initialChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Comments(
                postId: post.id,
                postMessage: post['Message'],
                postUser: post['UserEmail'],
                postRole: post['Role'],
                postTimestamp: post['TimeStamp'],
              );
            },
          );
        },
      );

      _isBottomSheetOpen = true;
      notifyListeners();

      _bottomSheetController?.closed.then((_) => closeBottomSheet());
    }
  }

  void closeBottomSheet() {
    if (_isBottomSheetOpen) {
      _bottomSheetController?.close();
      _isBottomSheetOpen = false;
      notifyListeners();
    }
  }

  // Optional: Add a method to toggle likes via Provider
  Future<void> toggleLike(String postId, bool isLiked) async {
    final postRef = _firestore.collection("User Posts").doc(postId);
    final currentUserEmail = _auth.currentUser!.email;

    if (isLiked) {
      await postRef.update({
        "Likes": FieldValue.arrayRemove([currentUserEmail]),
      });
    } else {
      await postRef.update({
        "Likes": FieldValue.arrayUnion([currentUserEmail]),
      });
    }
    notifyListeners();
  }

  void addComment(String postId, String commentText) {
    if (commentText.isNotEmpty) {
      _firestore
          .collection("User Posts")
          .doc(postId)
          .collection("Comments")
          .add({
        'text': commentText,
        'user': _auth.currentUser?.email,
        'timestamp': Timestamp.now(),
      });

      // Optionally update the comment count
      _firestore.collection("User Posts").doc(postId).update({
        'CommentCount': FieldValue.increment(1),
      });

      notifyListeners();
    }
  }
}
