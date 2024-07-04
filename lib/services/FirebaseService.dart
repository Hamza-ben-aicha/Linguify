import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Private constructor
  FirebaseService._privateConstructor();

  // Singleton instance
  static final FirebaseService instance = FirebaseService._privateConstructor();

  // Public factory
  factory FirebaseService() {
    return instance;
  }

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getters to expose the Firebase instances
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
}
