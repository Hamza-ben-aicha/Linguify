import 'dart:convert';
import 'dart:io';

import 'package:Linguify/constants/Constants.dart';
import 'package:Linguify/generated/l10n.dart';
import 'package:Linguify/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUpdatePage extends StatefulWidget {
  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final List<String> interests = [];
  final List<String> goals = [];
  final List<String> languagesToLearn = [];
  final List<String> nativeLanguages = [];
  final TextEditingController interestsController = TextEditingController();
  final TextEditingController goalsController = TextEditingController();
  final TextEditingController languagesToLearnController =
      TextEditingController();
  final TextEditingController nativeLanguagesController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  String gender = 'Male'; // Default gender
  File? _profileImage;

  final UserService _userServices = UserService(); // Initialize UserServices

  User? _currentUser;
  Map<String, dynamic>? _userData;
  DateTime? _selectedBirthdate;
  late Future<void> _loadUserDataFuture;

  @override
  void initState() {
    super.initState();
    _loadUserDataFuture = _loadUserDataFromPreferences();
  }

  Future<void> _loadUserDataFromPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString(keyUserData);
      if (userDataString != null) {
        _userData = json.decode(userDataString);
        setState(() {
          bioController.text = _userData?['bio'] ?? '';
          birthdateController.text = _userData?['birthdate'] ?? '';
          countryController.text = _userData?['country'] ?? '';
          gender = _userData?['gender'] ?? 'Male';

          interests.clear();
          interests.addAll(List<String>.from(_userData?['hobbies'] ?? []));
          print(interests);

          goals.clear();
          goals.addAll(List<String>.from(_userData?['goals'] ?? []));

          languagesToLearn.clear();
          languagesToLearn.addAll(
              List<String>.from(_userData?['languages_to_learn'] ?? []));

          nativeLanguages.clear();
          nativeLanguages
              .addAll(List<String>.from(_userData?['native_languages'] ?? []));

          // Set the selected birthdate
          String? birthdateString = _userData?['birthdate'];
          if (birthdateString != null && birthdateString.isNotEmpty) {
            _selectedBirthdate = DateTime.parse(birthdateString);
          }
        });
      }
    } catch (e) {
      print('Error loading user data from preferences: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _selectBirthdate(BuildContext context) async {
    DateTime initialDate = _selectedBirthdate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = picked;
        birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _updateUserDetails() async {
    try {
      _currentUser = await _userServices.getCurrentUser();
      await _userServices.updateUserDetails(
        _currentUser!.uid,
        interests: interests,
        goals: goals,
        languagesToLearn: languagesToLearn,
        nativeLanguage: nativeLanguages.isNotEmpty ? nativeLanguages[0] : null,
        accountImage: _profileImage,
        birthdate: birthdateController.text,
        bio: bioController.text,
        gender: gender,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).details_updated_successfully),
      ));
      Navigator.pop(context,true); // Navigate back after successful update
    } catch (e) {
      print('Error updating user details: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).failed_to_update_details),
      ));
    }
  }

  void _addChip(List<String> list, TextEditingController controller) {
    setState(() {
      if (controller.text.isNotEmpty) {
        list.add(controller.text);
        controller.clear();
      }
    });
  }

  Widget _buildChips(List<String> list) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Wrap(
        spacing: 10,
        children: list.map((item) {
          return Chip(
            label: Text(item),
            deleteIcon: Icon(Icons.cancel, size: 25, color: FIFTH_COLOR),
            deleteIconColor: SECONDARY_COLOR,
            onDeleted: () {
              setState(() {
                list.remove(item);
              });
            },
            backgroundColor: SECONDARY_COLOR,
            padding: EdgeInsets.symmetric(horizontal: 1),
            labelStyle: TextStyle(color: PRIMARY_COLOR),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: BorderSide(color: FIFTH_COLOR, width: 1),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required TextEditingController controller,
    required List<String> list,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(color: PRIMARY_COLOR),
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                  hintText: title,
                  contentPadding: EdgeInsets.only(left: 20, top: 30),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FIFTH_COLOR,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, color: SECONDARY_COLOR),
                        onPressed: () => _addChip(list, controller),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        _buildChips(list),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBar(
        title: Text('Update Profile',style: TextStyle(color: Colors.white),),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<void>(
            future: _loadUserDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading user data.'));
              } else {
                return ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : NetworkImage(
                                    _userData?['account_image'] ??
                                        'https://via.placeholder.com/150',
                                  ) as ImageProvider,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: FIFTH_COLOR,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: bioController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: SECONDARY_COLOR),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.only(left: 20),
                      ),
                      style: TextStyle(color: PRIMARY_COLOR),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectBirthdate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: birthdateController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: SECONDARY_COLOR),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.only(left: 20),
                          ),
                          style: TextStyle(color: PRIMARY_COLOR),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: countryController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: SECONDARY_COLOR),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.only(left: 20),
                      ),
                      style: TextStyle(color: PRIMARY_COLOR),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Gender',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio<String>(
                              value: 'Male',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
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
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                              activeColor: Colors.pink,
                            ),
                            Text(S.of(context).female, style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    _buildSection(
                      title: 'Interests',
                      controller: interestsController,
                      list: interests,
                    ),

                    _buildSection(
                      title: 'Goals',
                      controller: goalsController,
                      list: goals,
                    ),
                    _buildSection(
                      title: 'Languages to Learn',
                      controller: languagesToLearnController,
                      list: languagesToLearn,
                    ),
                    _buildSection(
                      title: 'Native Language',
                      controller: nativeLanguagesController,
                      list: nativeLanguages,
                    ),

                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateUserDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: THIRD_COLOR,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(fontSize: 18, color: PRIMARY_COLOR),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
