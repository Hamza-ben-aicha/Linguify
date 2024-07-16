import 'package:convocult/Constants/Constants.dart';
import 'package:convocult/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convocult/generated/l10n.dart';

class CompleteAccountPage2 extends StatefulWidget {
  final String username;

  CompleteAccountPage2({required this.username});

  @override
  _CompleteAccountPage2State createState() => _CompleteAccountPage2State();
}

class _CompleteAccountPage2State extends State<CompleteAccountPage2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  DateTime _selectedDate = DateTime(2000, 1, 1);
  String _selectedGender = 'Male';

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _selectDate(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateUserDetails() async {
    if (_formKey.currentState!.validate()) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String bio = _bioController.text;
      String birthdate = _selectedDate.toIso8601String();
      String gender = _selectedGender;
      File? accountImage = _imageFile != null ? File(_imageFile!.path) : null;

      UserService userService = UserService();

      await userService.updateUserDetails(
        uid,
        bio: bio,
        birthdate: birthdate,
        gender: gender,
        accountImage: accountImage,
        signupStep: 3,
      );

      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
                    child: _imageFile == null
                        ? Icon(Icons.add_a_photo, size: 50, color: PRIMARY_COLOR)
                        : Container(),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  S.of(context).hello+(widget.username),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              Text(S.of(context).birthdate, style: TextStyle(fontSize: 16, color: Colors.white)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.yMMMMd().format(_selectedDate),
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  hintText: S.of(context).biography,
                  filled: true,
                  fillColor: SECONDARY_COLOR,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: FIFTH_COLOR, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: THIRD_COLOR, width: 2),
                  ),
                ),
                style: TextStyle(color: PRIMARY_COLOR),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).enter_biography;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(S.of(context).gender, style: TextStyle(fontSize: 16, color: Colors.white)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: 'Male',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                        activeColor: Color(0xFF36D7DF),
                      ),
                      Text(S.of(context).male, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: 'Female',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                        activeColor: Colors.pink,
                      ),
                      Text(S.of(context).female, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _updateUserDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: THIRD_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                      bottomLeft: Radius.circular(26),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).next,
                      style: TextStyle(color: PRIMARY_COLOR),
                    ),
                    SizedBox(width: 8.0),
                    Icon(Icons.arrow_forward, color: PRIMARY_COLOR),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
