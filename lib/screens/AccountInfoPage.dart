import 'package:Linguify/Constants/Constants.dart';
import 'package:Linguify/generated/l10n.dart';
import 'package:Linguify/screens/AccountInfoPage2.dart';
import 'package:Linguify/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:Linguify/widgets/chips_input_section.dart';
import 'package:Linguify/widgets/section_input_field.dart';

class AccountInfoPage extends StatefulWidget {
  final String uid;

  const AccountInfoPage({Key? key, required this.uid}) : super(key: key);

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final List<String> interests = [];
  final List<String> interestIds = [];
  final List<String> goals = [];
  final List<String> languagesToLearn = [];
  final List<String> nativeLanguages = [];
  final TextEditingController goalsController = TextEditingController();
  final TextEditingController languagesToLearnController = TextEditingController();
  final TextEditingController nativeLanguagesController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();

  UserService _userServices = UserService();
  List<Map<String, String>> hobbies = [];

  @override
  void initState() {
    super.initState();
    _fetchHobbies();
  }

  Future<void> _fetchHobbies() async {
    try {
      List<Map<String, String>> fetchedHobbies = await _userServices.getHobbies();
      setState(() {
        hobbies = fetchedHobbies;
      });
    } catch (e) {
      print("Error fetching hobbies: $e");
    }
  }

  void _addHobbyChip(String hobby, String id) {
    if (!interests.contains(hobby)) {
      setState(() {
        interests.add(hobby);
        interestIds.add(id);
      });
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

  Future<void> _updateUserDetails() async {
    try {
      await _userServices.updateUserDetails(
        widget.uid,
        interests: interestIds,
        goals: goals,
        languagesToLearn: languagesToLearn,
        nativeLanguage: nativeLanguages.isNotEmpty ? nativeLanguages[0] : null,
        signupStep: 2,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).details_updated_successfully),
      ));
      Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteAccountPage2(username: "Hamza ben aicha")));
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
              ChipsInputSection(
                title: S.of(context).interests,
                controller: interestsController,
                list: interests,
                idList: interestIds,
                suggestions: hobbies,
                onSuggestionSelected: _addHobbyChip,
                onAddChip: () => _addChip(interests, interestsController),
              ),
              SectionInputField(
                title: S.of(context).goals,
                controller: goalsController,
                list: goals,
                idList: [],
                onAddChip: () => _addChip(goals, goalsController),
              ),
              SectionInputField(
                title: S.of(context).languages_to_learn,
                controller: languagesToLearnController,
                list: languagesToLearn,
                idList: [],
                onAddChip: () => _addChip(languagesToLearn, languagesToLearnController),
              ),
              SectionInputField(
                title: S.of(context).native_language,
                controller: nativeLanguagesController,
                list: nativeLanguages,
                idList: [],
                onAddChip: () => _addChip(nativeLanguages, nativeLanguagesController),
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
}
