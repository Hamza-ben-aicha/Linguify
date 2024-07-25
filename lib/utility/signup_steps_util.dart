// signup_steps_util.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Linguify/screens/AccountInfoPage.dart';
import 'package:Linguify/screens/AccountInfoPage2.dart';
import 'package:Linguify/screens/HomePage.dart';
import 'package:Linguify/services/user_service.dart';

Future<void> handleSignupSteps(BuildContext context, String uid) async {
  final userService = UserService();

  try {
    int? signupStep = await userService.getUserSignupStep(uid);

    if (signupStep != null) {
      if (signupStep == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AccountInfoPage(uid: uid),
          ),
        );
      } else if (signupStep == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteAccountPage2(username: "Your Username"), // Replace with actual username if available
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(e.toString()),
      ),
    );
  }
}
