import 'package:convocult/Constants/Constants.dart';
import 'package:flutter/material.dart';

class Forgetpasswordpage extends StatelessWidget {
  const Forgetpasswordpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Center(
          child: Text("This is forget password page",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
