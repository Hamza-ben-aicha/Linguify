import 'package:convocult/Constants/Constants.dart';
import 'package:convocult/generated/l10n.dart';
import 'package:convocult/screens/AccountInfoPage.dart';
import 'package:convocult/screens/LoginPage.dart';
import 'package:convocult/services/user_service.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Country? selectedCountry;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UserService _userServices = UserService(); // Initialize UserServices

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).passwords_do_not_match)));
      return;
    }

    try {
      User? user = await _userServices.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        fullnameController.text.trim(),
        selectedCountry?.name ?? 'Not specified',
      );

      if (user != null) {
        // Navigate to account info page and pass user UID
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountInfoPage(uid: user.uid)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).signup_failed)));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = S.of(context).email_already_in_use;
          break;
        case 'invalid-email':
          errorMessage = S.of(context).invalid_email;
          break;
        case 'weak-password':
          errorMessage = S.of(context).weak_password;
          break;
        default:
          errorMessage = S.of(context).unknown_error;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      print('Error signing up: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).signup_failed)));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).gettin_start,
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
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: fullnameController,
                  decoration: InputDecoration(
                    hintText: S.of(context).fullname,
                    filled: true,
                    fillColor: SECONDARY_COLOR,
                    suffixIcon: Icon(Icons.person, color: PRIMARY_COLOR),
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
                  style: TextStyle(color: PRIMARY_COLOR),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: S.of(context).email,
                    filled: true,
                    fillColor: SECONDARY_COLOR,
                    suffixIcon: Icon(Icons.email, color: PRIMARY_COLOR),
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
                  style: TextStyle(color: PRIMARY_COLOR),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountry = country;
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: SECONDARY_COLOR,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: FIFTH_COLOR, width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_drop_down, color: PRIMARY_COLOR),
                        SizedBox(width: 10),
                        Text(
                          selectedCountry == null
                              ? S.of(context).select_country
                              : selectedCountry!.name,
                          style: TextStyle(color: PRIMARY_COLOR),
                        ),
                        Spacer(),
                        Icon(Icons.flag, color: PRIMARY_COLOR),
                      ],
                    ),
                  ),
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
                    suffixIcon: Icon(Icons.lock, color: PRIMARY_COLOR),
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
                  style: TextStyle(color: PRIMARY_COLOR),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: S.of(context).confrim_password,
                    filled: true,
                    fillColor: SECONDARY_COLOR,
                    suffixIcon: Icon(Icons.lock, color: PRIMARY_COLOR),
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
                  style: TextStyle(color: PRIMARY_COLOR),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
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
                      signUp();
                    },
                    child: Text(
                      S.of(context).signup,
                      style: TextStyle(fontSize: 20, color: PRIMARY_COLOR),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: S.of(context).already_have_account,
                    style: TextStyle(color: Colors.grey),
                    children: <TextSpan>[
                      TextSpan(
                        text: S.of(context).signin,
                        style: TextStyle(
                          color: FIFTH_COLOR,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Loginpage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
