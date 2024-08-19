import 'package:Linguify/Constants/Constants.dart';
import 'package:Linguify/generated/l10n.dart';
import 'package:Linguify/screens/ProfileUpdatePage.dart';
import 'package:Linguify/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  UserService userService = UserService();
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    List<Map<String, String>> hobies = await userService.getHobbies();


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    print(userDataString);
    if (userDataString != null) {
      setState(() {
        userData = json.decode(userDataString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      S.of(context).profile,
                      style: TextStyle(
                        color: SECONDARY_COLOR,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.edit,color: Colors.white,),
                        onPressed: () async  {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileUpdatePage()),
                          );
                          if (result == true) {
                            _loadUserData();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white10,height: 10,),


                SizedBox(height: 40),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(1), // Border width
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: THIRD_COLOR, // Border color
                        ),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(
                            userData['account_image'] ??
                                'https://via.placeholder.com/150', // Placeholder image
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: FIFTH_COLOR,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Text(
                        userData['full_name'] ?? S.of(context).loading,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userData['email'] ?? S.of(context).loading,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.white54),
                buildProfileInfo('Bio', userData['bio'] ?? S.of(context).loading, 'bio', context),
                buildProfileInfo('Country', userData['country'] ?? S.of(context).loading, 'country', context),
                buildProfileInfo('Gender', userData['gender'] ?? 'Male', 'gender', context),
                buildProfileInfo('Birthdate', userData['birthdate'] ?? S.of(context).loading, 'birthdate', context),
                buildProfileInfo('Goals', (userData['goals'] ?? [S.of(context).loading, S.of(context).loading]).join(', '), 'goals', context),
                buildProfileInfo('Intrests', (userData['hobbies'] ?? [', ']).join(', '), 'interests', context),
                buildProfileInfo('Languages to learn', (userData['languages_to_learn'] ?? [', ']).join(', '), 'languages_to_learn', context),
                buildProfileInfo('Native languages', (userData['native_languages'] ?? [', ']).join(', '), 'native_language', context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileInfo(String title, String content, String fieldKey, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            content,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
        Divider(color: Colors.white24),
      ],
    );
  }
}