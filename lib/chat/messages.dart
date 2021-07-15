import 'package:chat/chat/message_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  final _currentUserId = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        final doc = snapShot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: doc.length,
          itemBuilder: (ctx, index) => MessageBubbles(
            doc[index]['text'],
            doc[index]['userId'] == _currentUserId,
            doc[index]['username'],
            doc[index]['userImage'],
          ),
        );
      },
    );
  }
}
