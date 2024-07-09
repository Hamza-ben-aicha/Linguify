import 'package:convocult/Constants/Constants.dart';
import 'package:convocult/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

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
      String uid = FirebaseAuth.instance.currentUser!.uid; // Get current user's UID
      String bio = _bioController.text;
      String birthdate = _selectedDate.toIso8601String();
      String gender = _selectedGender;
      String? accountImage = _imageFile?.path;

      // Create an instance of UserService
      UserService userService = UserService();

      // Call updateUserDetails method
      await userService.updateUserDetails(
        uid,
        bio: bio,
        birthdate: birthdate,
        gender: gender,
        accountImage: accountImage,
        signupStep:3,
      );

      // Navigate to the next screen or show a success message
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User details updated successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
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
                    backgroundImage: _imageFile == null
                        ? AssetImage('assets/placeholder.png')
                        : FileImage(File(_imageFile!.path)) as ImageProvider,
                    child: _imageFile == null
                        ? Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                        : Container(),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Hello ${widget.username}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Birthdate', style: TextStyle(fontSize: 16, color: Colors.white)),
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
                  labelText: 'Biography',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF1B263B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your biography';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Gender', style: TextStyle(fontSize: 16, color: Colors.white)),
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
                        activeColor: Colors.blue,
                      ),
                      Text('Male', style: TextStyle(color: Colors.white)),
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
                      Text('Female', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _updateUserDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD6BA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
