import 'package:Linguify/Constants/Constants.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Center(
        child: Text('This is the Chat Page',style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
