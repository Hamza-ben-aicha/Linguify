import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ConversationPage.dart';
import 'package:Linguify/Constants/Constants.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: Text('Chats', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .where('participants', arrayContains: currentUser?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No conversations yet.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var conversation = snapshot.data!.docs[index];
              var participants = conversation['participants'] as List<dynamic>;

              // Identify the other participant (receiver)
              var receiverId = participants.firstWhere((id) => id != currentUser?.uid, orElse: () => null);

              if (receiverId == null) {
                return Container(); // Skip if no valid receiver
              }

              var lastMessage = conversation['lastMessage'] ?? 'No messages yet';
              var lastMessageSeenByReceiver = conversation['seenBy']?.contains(currentUser?.uid) ?? true;

              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('users').doc(receiverId).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(); // Loading state for user data
                  }

                  if (!userSnapshot.hasData) {
                    return Container(); // No user data available
                  }

                  var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                  var receiverName = userData?['full_name'] ?? 'Unknown User';
                  var receiverImage = userData?['account_image'] ?? 'assets/images/default_profile.png';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: receiverImage != 'assets/images/default_profile.png'
                          ? NetworkImage(receiverImage)
                          : AssetImage('assets/images/default_profile.png') as ImageProvider,
                    ),
                    title: Text(
                      receiverName,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      lastMessage,
                      style: TextStyle(
                        color: lastMessageSeenByReceiver ? Colors.grey : Colors.orange,
                        fontWeight: lastMessageSeenByReceiver ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationPage(
                            receiverId: receiverId,
                            receiverName: receiverName,
                            receiverImage: receiverImage,
                            currentUserId: currentUser?.uid ?? '',
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
