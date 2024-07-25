import 'package:Linguify/Constants/Constants.dart';
import 'package:Linguify/services/user_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Linguify/generated/l10n.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final UserService _userService = UserService();

  void _sendPasswordResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      await _userService.sendPasswordResetEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).password_reset_email_sent)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).enter_email_address)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  S.of(context).forgot_password,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 100),
                Text(
                  S.of(context).enter_your_email,
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: S.of(context).email,
                      filled: true,
                      fillColor: SECONDARY_COLOR,
                      suffixIcon: Icon(Icons.email, color: SIXTH_COLOR),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: FIFTH_COLOR, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: THIRD_COLOR, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: THIRD_COLOR,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                            bottomLeft: Radius.circular(26),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _sendPasswordResetEmail();
                      },
                      child: Text(
                        S.of(context).send_password_reset_email,
                        style: TextStyle(fontSize: 20, color: PRIMARY_COLOR),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: S.of(context).remembered_password,
                    style: TextStyle(color: Colors.grey),
                    children: <TextSpan>[
                      TextSpan(
                        text: S.of(context).signin,
                        style: TextStyle(
                          color: FIFTH_COLOR,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
