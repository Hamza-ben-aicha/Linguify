import 'package:convocult/Constants/Constants.dart';
import 'package:convocult/generated/l10n.dart';
import 'package:convocult/screens/AccountInfoPage2.dart';
import 'package:convocult/services/user_service.dart';
import 'package:flutter/material.dart';


class AccountInfoPage extends StatefulWidget {
  final String uid; // Define uid as a parameter

  const AccountInfoPage({Key? key, required this.uid}) : super(key: key);

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}



class _AccountInfoPageState extends State<AccountInfoPage> {
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

  UserService _userServices = UserService(); // Initialize UserServices

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
            deleteIcon: Icon(Icons.cancel, size: 25, color: FIFTH_COLOR), // Changed icon to cancel icon
            deleteIconColor: SECONDARY_COLOR,
            onDeleted: () {
              setState(() {
                list.remove(item);
              });
            },
            backgroundColor: SECONDARY_COLOR, // Background color of the chip
            padding: EdgeInsets.symmetric(horizontal: 1), // Padding of the chip
            labelStyle: TextStyle(color: PRIMARY_COLOR), // Text color of the chip
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40), // Radius of the chip
              side: BorderSide(color: FIFTH_COLOR, width: 1), // Border color and width of the chip
            ),
          );
        }).toList(),
      ),
    );
  }


  Future<void> _updateUserDetails() async {
    try {
      await _userServices.updateUserDetails(
        widget.uid,
        interests: interests,
        goals: goals,
        languagesToLearn: languagesToLearn,
        nativeLanguage: nativeLanguages.isNotEmpty ? nativeLanguages[0] : null,// Assuming only one native language is selected
        signupStep : 2, // Update signup_step to 2,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).details_updated_successfully),
      ));
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CompleteAccountPage2(username: "Hamza ben aicha")));
    } catch (e) {
      print('Error updating user details: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).failed_to_update_details),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: Text(
                  S.of(context).complete_accoun1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SECONDARY_COLOR,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildSection(
                title: S.of(context).interests,
                controller: interestsController,
                list: interests,
              ),
              _buildSection(
                title: S.of(context).goals,
                controller: goalsController,
                list: goals,
              ),
              _buildSection(
                title: S.of(context).languages_to_learn,
                controller: languagesToLearnController,
                list: languagesToLearn,
              ),
              _buildSection(
                title: S.of(context).native_language,
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
                  S.of(context).next,
                  style: TextStyle(fontSize: 18, color: PRIMARY_COLOR),
                ),
              ),
            ],
          ),
        ),
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
}
