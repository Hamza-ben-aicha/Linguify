import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservice {

  ///instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///sign in
  // Future<UserCredential> signInWithEmailPassword(String email,password) async {
  //   try{
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     return userCredential;
  //   } on FirebaseAuthException catch (e){
  //     throw Exception(e.code);
  //   }
  // }

  /// Sign in
  Future<Map<String, dynamic>> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      String? token = await userCredential.user?.getIdToken();

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user?.uid).get();

      if (userDoc.exists) {
        return {
          'token': token,
          'userData': userDoc.data(),
          'uid':userCredential.user?.uid
        };
      } else {
        throw Exception('User document does not exist');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  ///sign up
  // Future<UserCredential> signUpWithEmailPassword(String email,password) async {
  //   try{
  //     UserCredential userCredential = await  _auth.createUserWithEmailAndPassword(email: email, password: password);
  //     return userCredential;
  //   } on FirebaseAuthException catch (e){
  //     throw Exception(e.code);
  //   }
  // }

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String country,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(fullName);

      // Save additional user data to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'full_name': fullName,
        'email': email,
        'country': country,
      });
    } on FirebaseAuthException catch (e) {
      throw e; // Rethrow the error so it can be handled in the UI
    }
  }
  ///sign out

  ///errors

}
