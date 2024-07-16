import 'package:convocult/shared%20preference/SharedPreferencesManager.dart';
import 'package:flutter/material.dart';
import 'package:convocult/Constants/Constants.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({required this.userData, super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController fullNameController;
  late TextEditingController bioController;
  late TextEditingController countryController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.userData['full_name']);
    bioController = TextEditingController(text: widget.userData['bio']);
    countryController = TextEditingController(text: widget.userData['country']);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    bioController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final prefsManager = SharedPreferencesManager();
    Map<String, dynamic> updatedData = {
      ...widget.userData,
      'full_name': fullNameController.text,
      'bio': bioController.text,
      'country': countryController.text,
    };
    await prefsManager.saveUserData(updatedData);
    Navigator.pop(context, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(fullNameController, 'Full Name'),
            SizedBox(height: 10),
            _buildTextField(bioController, 'Bio'),
            SizedBox(height: 10),
            _buildTextField(countryController, 'Country'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: THIRD_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: SECONDARY_COLOR,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: THIRD_COLOR),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
