import 'package:chat/widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatmessage extends StatelessWidget {
  const Chatmessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data != null) {
          return const Center(
            child: Text('no message found'),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('error'),
          );
        }
        final loadedmessage = snapshot.data!.docs;
        return ListView.builder(
          itemCount: loadedmessage.length,
          itemBuilder: (ctx, Index) {
            final Chatmessage = loadedmessage[Index].data();
            final nextmessage = Index + 1 < loadedmessage.length
                ? loadedmessage[Index + 1].data()
                : null;
            final currentmessageuserid = Chatmessage['userId'];
            final nextmessageuserid =
                nextmessage != null ? Chatmessage['userId'] : null;
            final bool nextuserissame =
                nextmessageuserid == currentmessageuserid;
            if (nextuserissame) {
              return MessageBubble.next(
                  message: Chatmessage['text'],
                  isMe: authUser!.uid == currentmessageuserid);
            } else {
              return MessageBubble.first(
                  userImage: Chatmessage['userimage'],
                  username: Chatmessage['username'],
                  message: Chatmessage['text'],
                  isMe: authUser!.uid == currentmessageuserid);
            }
          },
        );
      },
    );
  }
}
