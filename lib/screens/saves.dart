import 'package:Linguify/Constants/Constants.dart';
import 'package:Linguify/screens/EditProfilePage.dart';
import 'package:Linguify/shared%20preference/SharedPreferencesManager.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    final prefsManager = SharedPreferencesManager();
    return await prefsManager.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: PRIMARY_COLOR,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              Map<String, dynamic>? userData = await _getUserData();
              if (userData != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(userData: userData),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              );
            } else if (snapshot.hasData) {
              Map<String, dynamic>? userData = snapshot.data;
              if (userData == null) {
                return Text(
                  'No user data found',
                  style: TextStyle(color: Colors.white),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userData['account_image']),
                    ),
                    SizedBox(height: 20),
                    Text(
                      userData['full_name'] ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildProfileItem('Email', userData['email']),
                    _buildProfileItem('Country', userData['country']),
                    _buildProfileItem('Bio', userData['bio']),
                    _buildProfileItem('Gender', userData['gender']),
                    _buildProfileItem('Birthdate', userData['birthdate']),
                    _buildProfileItem('Languages to Learn', userData['languages_to_learn']?.join(', ')),
                    _buildProfileItem('Native Language', userData['native_language']),
                    _buildProfileItem('Interests', userData['interests']?.join(', ')),
                    _buildProfileItem('Goals', userData['goals']?.join(', ')),
                  ],
                ),
              );
            } else {
              return Text(
                'No user data found',
                style: TextStyle(color: Colors.white),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
