import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Newmessage extends StatefulWidget {
  const Newmessage({super.key});

  @override
  _NewmessageState createState() => _NewmessageState();
}

class _NewmessageState extends State<Newmessage> {
  final _messagecontroller = TextEditingController();
  String? _username;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      setState(() {
        _username = userData['username'];
      });
    }
  }

  @override
  void dispose() {
    _messagecontroller.dispose();
    super.dispose();
  }

  void _sendmessage() async {
    final enteredMessage = _messagecontroller.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messagecontroller.clear();

    try {
      await FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'username': _username ?? 'Unknown',
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
      print('Message sent: $enteredMessage');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        bottom: 16,
        top: 1,
        right: 1,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messagecontroller,
              decoration: const InputDecoration(
                labelText: 'Send a message...',
              ),
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            onPressed: _sendmessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
