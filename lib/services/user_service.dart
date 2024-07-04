import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convocult/models/User.dart';
import 'package:convocult/services/FirebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseService _firebaseService = FirebaseService.instance;

  Future<User?> signUp(String email, String password, String fullName, String country) async {
    try {
      UserCredential userCredential = await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firebaseService.firestore.collection('users').doc(user.uid).set({
          'full_name': fullName,
          'country': country,
        });
      }
      return user;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<void> updateUserDetails(String uid, {List<String>? interests, List<String>? goals, List<String>? languagesToLearn, String? nativeLanguage, String? accountImage, String? birthdate, String? bio, String? gender}) async {
    Map<String, dynamic> data = {};

    if (interests != null) data['interests'] = interests;
    if (goals != null) data['goals'] = goals;
    if (languagesToLearn != null) data['languages_to_learn'] = languagesToLearn;
    if (nativeLanguage != null) data['native_language'] = nativeLanguage;
    if (accountImage != null) data['account_image'] = accountImage;
    if (birthdate != null) data['birthdate'] = birthdate;
    if (bio != null) data['bio'] = bio;
    if (gender != null) data['gender'] = gender;

    try {
      await _firebaseService.firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Error updating user details: $e');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firebaseService.firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Login user
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

}
