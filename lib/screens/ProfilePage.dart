import 'package:convocult/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      setState(() {
        userData = json.decode(userDataString);
      });
    }
  }

  Future<void> _showEditDialog(String title, String fieldKey) async {
    TextEditingController controller = TextEditingController();
    String uid = 'user-uid'; // Replace with the actual user UID

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: 'Enter new $title'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () async {
                String newValue = controller.text;
                // await updateUserDetails(uid, {fieldKey: newValue});
                setState(() {
                  userData[fieldKey] = newValue;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //
  // Future<void> updateUserDetails(String uid, Map<String, dynamic> data) async {
  //   try {
  //     await _firebaseService.firestore.collection('users').doc(uid).update(data);
  //   } catch (e) {
  //     print('Error updating user details: $e');
  //   }
  // }

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
                Text(
                  "Profile",
                  style: TextStyle(
                    color: SECONDARY_COLOR,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          userData['account_image'] ??
                              'https://via.placeholder.com/150', // Placeholder image
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
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              // Implement edit profile picture functionality
                            },
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
                        userData['full_name'] ?? 'FullName',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userData['email'] ?? 'Email@gmail.com',
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
                buildProfileInfo('Bio', userData['bio'] ?? 'bio with extra light font', 'bio', context),
                buildProfileInfo('Country', userData['country'] ?? 'Tunisia', 'country', context),
                buildProfileInfo('Gender', userData['gender'] ?? 'Male', 'gender', context),
                buildProfileInfo('Birthdate', userData['birthdate'] ?? '2000/10/5', 'birthdate', context),
                buildProfileInfo('Goals', (userData['goals'] ?? ['goal1', 'goal2', 'goal3', 'goal4', 'goal5']).join(', '), 'goals', context),
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
          trailing: IconButton(
            icon: Icon(Icons.edit, color: Colors.white70),
            onPressed: () {
              _showEditDialog(title, fieldKey);
            },
          ),
        ),
        Divider(color: Colors.white54),
      ],
    );
  }
}
