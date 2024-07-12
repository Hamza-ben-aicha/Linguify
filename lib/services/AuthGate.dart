import 'package:convocult/Constants/Constants.dart';
import 'package:convocult/screens/HomePage.dart';
import 'package:convocult/screens/LoginPage.dart';
import 'package:convocult/screens/SignUpPage.dart';
import 'package:convocult/services/user_service.dart';
import 'package:convocult/utility/signup_steps_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return Loginpage();
          } else {
            // Use the handleSignupSteps function to navigate to the correct page
            return FutureBuilder(
              future: handleSignupSteps(context, user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return HomePage(); // Default page if Future completes successfully
                } else {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                    ),
                  );
                }
              },
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
