  import 'package:Linguify/Constants/Constants.dart';
  import 'package:Linguify/generated/l10n.dart';
  import 'package:Linguify/screens/ForgetPasswordPage.dart';
  import 'package:Linguify/screens/SignUpPage.dart';
  import 'package:Linguify/services/user_service.dart';
  import 'package:Linguify/shared%20preference/SharedPreferencesManager.dart';
  import 'package:Linguify/utility/signup_steps_util.dart';
  import 'package:flutter/gestures.dart';
  import 'package:flutter/material.dart';

  class Loginpage extends StatelessWidget {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final prefsManager = SharedPreferencesManager(); // Create an instance of SharedPreferencesManager

    Loginpage({super.key});

    void login(BuildContext context) async {
      final userService = UserService();
      try {
        final result = await userService.signInWithEmailPassword(
          emailController.text,
          passwordController.text,
        );

        if (result != null) {

          print(result);
          print(prefsManager.getUserData());
          await handleSignupSteps(context, result.uid);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).welcome,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        height: 150,
                        child: Image.asset("assets/images/convo_cult_icon.png"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    S.of(context).signin,
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: emailController,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: S.of(context).password,
                        filled: true,
                        fillColor: SECONDARY_COLOR,
                        suffixIcon: Icon(Icons.lock, color: SIXTH_COLOR),
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
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          S.of(context).forget_password,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
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
                          login(context);
                        },
                        child: Text(
                          S.of(context).signin,
                          style: TextStyle(fontSize: 20, color: PRIMARY_COLOR),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: S.of(context).dont_have_account,
                      style: TextStyle(color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                          text: S.of(context).signup,
                          style: TextStyle(
                            color: FIFTH_COLOR,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpPage()),
                              );
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
