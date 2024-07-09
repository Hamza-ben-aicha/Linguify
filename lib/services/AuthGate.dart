import 'package:convocult/screens/HomePage.dart';
import 'package:convocult/screens/LoginPage.dart';
import 'package:convocult/services/FirebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }
      ///user logged in

      if(snapshot.hasData){
        return  HomePage();
      }
      ///user is not logged in
      else{
        return  Loginpage();
      }
    },
    ),);
  }
}
