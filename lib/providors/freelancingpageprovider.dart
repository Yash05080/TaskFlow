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
    QuerySnapshot postsSnapshot = await _firestore.collection("User Posts").get();

    for (var post in postsSnapshot.docs) {
      try {
        post.get('CommentCount');
      } catch (e) {
        await _firestore.collection("User Posts").doc(post.id).update({'CommentCount': 0});
      }
    }
    notifyListeners();
  }

  Future<void> _fetchUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection("users").doc(user.uid).get();
      if (snapshot.exists) {
        _userRole = snapshot["role"] ?? "Employee";
      }
      notifyListeners();
    }
  }

  void postMessage() {
    if (textController.text.isNotEmpty) {
      _firestore.collection("User Posts").add({
        'UserEmail': _auth.currentUser?.email,
        'Message': textController.text,
        'Role': _userRole,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'CommentCount': 0,
      });
      textController.clear();
      notifyListeners();
    }
  }

  void openBottomSheet(BuildContext context, DocumentSnapshot post) {
    if (_isBottomSheetOpen) {
      closeBottomSheet();
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
}
