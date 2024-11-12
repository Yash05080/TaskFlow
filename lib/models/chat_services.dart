import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through ach individual user
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  //send message

  Future<void> sendMessage(String recieverID, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a message
    Message newMessage = Message(
        message: message,
        receiverID: recieverID,
        senderEmail: currentUserEmail,
        senderID: currentUserID,
        timestamp: timestamp);

    //create a chat room idfor the two users (sorted)
    List<String> ids = [currentUserID, recieverID];
    ids.sort(); // with this a-b is same as b-a meaning same chat room for a pair
    String chatroomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatroomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userID, otheruserID) {
    //construct chatroom Idfor the two users

    List<String> ids = [userID, otheruserID];
    ids.sort();
    String chatroomID = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatroomID)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
