import 'package:Linguify/screens/LoginPage.dart';
import 'package:Linguify/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Linguify/Constants/Constants.dart'; // Adjust the import according to your file structure

class SettingsPage extends StatelessWidget {
  final UserService userService = UserService();

  void _disconnect(BuildContext context){
    userService.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Loginpage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBar(
        titleTextStyle: TextStyle(fontWeight:FontWeight.bold),
        backgroundColor: PRIMARY_COLOR,
        title: Text("Settings"),
        actions: [
          IconButton(onPressed: ()=> _disconnect(context), icon: Icon(Icons.logout,color: Colors.white,))
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'This is the Settings Page',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _disconnect(context),
                child: Text('Disconnect',style: TextStyle(color: PRIMARY_COLOR),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
