import 'package:convocult/Constants/Constants.dart';
import 'package:convocult/generated/l10n.dart';
import 'package:convocult/screens/LoginPage.dart';
import 'package:convocult/services/AuthGate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/images/convo_cult_icon.png",
              width: 400,
              height: 400,
            ),
            SizedBox(height: 20),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom:100,left: 40,right: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AuthGate()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: THIRD_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        bottomLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(S.of(context).next,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
