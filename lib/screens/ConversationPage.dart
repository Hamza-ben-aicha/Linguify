import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ConversationPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final String currentUserId;

  ConversationPage({
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    required this.currentUserId,
  });

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String messageText = _messageController.text.trim();
    _messageController.clear();

    await _firestore.collection('conversations').doc(_getConversationId()).collection('messages').add({
      'senderId': widget.currentUserId,
      'receiverId': widget.receiverId,
      'message': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'seen': false,
    });

    // Update conversation with last message and seen status
    await _firestore.collection('conversations').doc(_getConversationId()).set({
      'lastMessage': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'seenBy': [widget.currentUserId], // Only the sender has seen it
      'participants': [widget.currentUserId, widget.receiverId],
    }, SetOptions(merge: true));
  }

  String _getConversationId() {
    List<String> participants = [widget.currentUserId, widget.receiverId];
    participants.sort(); // Sort to ensure the same ID regardless of sender/receiver
    return participants.join('_');
  }

  void _markMessagesAsSeen(QuerySnapshot messageSnapshot) async {
    for (var doc in messageSnapshot.docs) {
      if (doc['receiverId'] == widget.currentUserId && !(doc['seen'] as bool)) {
        try {
          // Ensure the document exists before updating
          DocumentSnapshot documentSnapshot = await doc.reference.get();
          if (documentSnapshot.exists) {
            await doc.reference.update({'seen': true});
          }
        } catch (e) {
          // Handle the error by logging or ignoring it
          print('Error updating seen status: $e');
        }
      }
    }

    // Mark the conversation as seen by the current user
    try {
      DocumentSnapshot conversationDoc = await _firestore.collection('conversations').doc(_getConversationId()).get();
      if (conversationDoc.exists) {
        await _firestore.collection('conversations').doc(_getConversationId()).update({
          'seenBy': FieldValue.arrayUnion([widget.currentUserId]),
        });
      }
    } catch (e) {
      // Handle the error by logging or ignoring it
      print('Error updating conversation seen status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.receiverImage.isNotEmpty
                  ? NetworkImage(widget.receiverImage)
                  : AssetImage('assets/images/default_profile.png') as ImageProvider,
            ),
            SizedBox(width: 10),
            Text(widget.receiverName),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('conversations')
                  .doc(_getConversationId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                _markMessagesAsSeen(snapshot.data!); // Mark messages as seen when loaded

                return ListView.builder(
                  reverse: true, // Show newest messages at the bottom
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    var isCurrentUser = message['senderId'] == widget.currentUserId;
                    var messageText = message['message'];
                    var timestamp = (message['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                    var formattedTime = DateFormat('hh:mm a').format(timestamp);

                    return ListTile(
                      title: Align(
                        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.blue : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                messageText,
                                style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black),
                              ),
                              SizedBox(height: 5),
                              Text(
                                formattedTime,
                                style: TextStyle(fontSize: 10, color: isCurrentUser ? Colors.white70 : Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
