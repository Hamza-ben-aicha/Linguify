import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Linguify/models/User.dart';
import 'package:Linguify/services/FirebaseService.dart';
import 'package:Linguify/shared%20preference/SharedPreferencesManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  Timer? _tokenRefreshTimer;

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
          'email': email
        });
      }
      return user;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<void> updateUserDetails(String uid, {
    List<String>? interests,
    List<String>? goals,
    List<String>? languagesToLearn,
    String? nativeLanguage,
    File? accountImage,
    String? birthdate,
    String? bio,
    String? gender,
    int? signupStep,
  }) async {
    Map<String, dynamic> data = {};

    if (interests != null) data['interests'] = interests;
    if (goals != null) data['goals'] = goals;
    if (languagesToLearn != null) data['languages_to_learn'] = languagesToLearn;
    if (nativeLanguage != null) data['native_language'] = nativeLanguage;
    if (accountImage != null) {
      // Upload image to Firebase Storage
      Reference storageRef = _firebaseService.storage.ref().child('user_images').child(uid + '.jpg');
      await storageRef.putFile(accountImage);
      String downloadUrl = await storageRef.getDownloadURL();
      data['account_image'] = downloadUrl;
    }
    if (birthdate != null) data['birthdate'] = birthdate;
    if (bio != null) data['bio'] = bio;
    if (gender != null) data['gender'] = gender;
    if (signupStep != null) data['signup_step'] = signupStep;

    try {
      // Update user details in the 'users' collection
      await _firebaseService.firestore.collection('users').doc(uid).update(data);

      // Update interests in the 'UserHobbies' collection
      if (interests != null) {
        // Remove existing entries for this user in UserHobbies
        var existingHobbies = await _firebaseService.firestore
            .collection('UserHobbies')
            .where('userId', isEqualTo: uid)
            .get();

        for (var doc in existingHobbies.docs) {
          await doc.reference.delete();
        }

        // Add new entries
        for (var interestId in interests) {
          await _firebaseService.firestore.collection('UserHobbies').add({
            'userId': uid,
            'interestId': interestId,
          });
        }
      }

      await _sharedPreferencesManager.saveUserData(data);
    } catch (e) {
      print('Error updating user details: $e');
    }
  }


  Future<int?> getUserSignupStep(String uid) async {
    try {
      DocumentSnapshot doc = await _firebaseService.firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        return data['signup_step'] as int?;
      }
    } catch (e) {
      print('Error getting signup step: $e');
    }
    return null;
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firebaseService.firestore.collection('users').doc(uid).get();
      return userDoc;
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }



  Future<List<String>> _getUserHobbies(String uid) async {
    try {
      print('User id -----> $uid');
      QuerySnapshot snapshot = await _firebaseService.firestore
          .collection('UserHobbies')
          .where('userId', isEqualTo: uid)
          .get();
      return snapshot.docs.map((doc) => doc['interestId'] as String).toList();
    } catch (e) {
      print('Error getting user hobbies: $e');
      throw e;
    }
  }

  Future<List<String>> _getUserLanguages(String uid, bool isNative) async {
    try {
      QuerySnapshot snapshot = await _firebaseService.firestore
          .collection('userLanguages')
          .where('userId', isEqualTo: uid)
          .where('isNative', isEqualTo: isNative)
          .get();
      return snapshot.docs.map((doc) => doc['languageId'] as String).toList();
    } catch (e) {
      print('Error getting user languages: $e');
      throw e;
    }
  }
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
      await _firebaseService.auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc =
        await _firebaseService.firestore.collection('users').doc(user.uid).get();
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Fetch user's hobbies and languages
        List<String> hobbies = await _getUserHobbies(user.uid);
        List<String> languagesToLearn = await _getUserLanguages(user.uid, false);
        List<String> nativeLanguages = await _getUserLanguages(user.uid, true);

        print(hobbies);
        // Add hobbies and languages to userData
        userData['hobbies'] = hobbies;
        userData['languages_to_learn'] = languagesToLearn;
        userData['native_languages'] = nativeLanguages;

        // Save user data to SharedPreferences
        await _sharedPreferencesManager.saveUserData(userData);

        return user;
      }
      return null;
    } catch (e) {
      print('Error signing in with email and password: $e');
      throw e;
    }
  }

  Future<void> signOut() async {
    _cancelTokenRefresh();
    return await _firebaseService.auth.signOut();
  }

  void _setupTokenRefresh() {
    // Cancel any existing timer
    _cancelTokenRefresh();

    // Set up a new timer to refresh the token every 55 minutes
    _tokenRefreshTimer = Timer.periodic(Duration(minutes: 55), (timer) async {
      try {
        User? user = _firebaseService.auth.currentUser;
        if (user != null) {
          await user.getIdToken(true); // Force refresh the token
        }
      } catch (e) {
        print('Error refreshing token: $e');
      }
    });
  }

  void _cancelTokenRefresh() {
    _tokenRefreshTimer?.cancel();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent');
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }

  // Function to get the current logged in user's UID
  String? getCurrentUserUID() {
    User? user = _firebaseService.auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  // Function to get the current logged-in user
  User? getCurrentUser() {
    return _firebaseService.auth.currentUser;
  }


  Future<List<Map<String, String>>> getHobbies() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.firestore.collection('hobbies').get();
      List<Map<String, String>> hobbies = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'hobby': doc['hobby'] as String,
        };
      }).toList();
      return hobbies;
    } catch (e) {
      print("Error fetching hobbies: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      // Get user document from 'users' collection
      DocumentSnapshot userDoc = await _firebaseService.firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Get user hobbies from 'UserHobbies' collection
        QuerySnapshot hobbiesSnapshot = await _firebaseService.firestore
            .collection('UserHobbies')
            .where('userId', isEqualTo: uid)
            .get();

        List<String> hobbiesIds = hobbiesSnapshot.docs.map((doc) => doc['interestId'] as String).toList();

        // Get hobbies names from 'hobbies' collection
        List<Map<String, String>> hobbiesList = [];
        for (String hobbyId in hobbiesIds) {
          DocumentSnapshot hobbyDoc = await _firebaseService.firestore.collection('hobbies').doc(hobbyId).get();
          if (hobbyDoc.exists) {
            hobbiesList.add({
              'id': hobbyDoc.id,
              'name': hobbyDoc['hobby'],
            });
          }
        }

        // Add hobbies to user data
        userData['interests'] = hobbiesList;

        return userData;
      }
    } catch (e) {
      print('Error getting user profile: $e');
    }
    return null;
  }

}
