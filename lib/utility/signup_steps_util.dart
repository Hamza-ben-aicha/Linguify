// signup_steps_util.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convocult/screens/AccountInfoPage.dart';
import 'package:convocult/screens/AccountInfoPage2.dart';
import 'package:convocult/screens/HomePage.dart';
import 'package:convocult/services/user_service.dart';

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
