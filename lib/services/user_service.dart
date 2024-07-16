import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convocult/models/User.dart';
import 'package:convocult/services/FirebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Timer for periodic token refresh
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
      await _firebaseService.firestore.collection('users').doc(uid).update(data);
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

      // Setup token refresh
      _setupTokenRefresh();

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseService.auth.signInWithEmailAndPassword(email: email, password: password);
      String? token = await userCredential.user?.getIdToken(true);

      DocumentSnapshot userDoc = await _firebaseService.firestore.collection('users').doc(userCredential.user?.uid).get();

      if (userDoc.exists) {
        // Setup token refresh
        _setupTokenRefresh();

        return {
          'token': token,
          'userData': userDoc.data(),
          'uid': userCredential.user?.uid
        };
      } else {
        throw Exception('User document does not exist');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
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


  Future<List<String>> getHobbies() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.firestore.collection('hobbies').get();
      List<String> hobbies = querySnapshot.docs.map((doc) => doc['hobby'] as String).toList();
      return hobbies;
    } catch (e) {
      print("Error fetching hobbies: $e");
      return [];
    }
  }
}
