import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Linguify/services/FirebaseService.dart';

class UserHobbiesService {
  final FirebaseService _firebaseService = FirebaseService();
  Future<void> addUserHobby(String userId, String hobbyId) async {
    try {
      await _firebaseService.firestore.collection('userHobbies').add({
        'userId': userId,
        'hobbyId': hobbyId,
      });
    } catch (e) {
      print('Error adding user hobby: $e');
      throw e; // You can handle errors as needed
    }
  }
  Future<List<Map<String, String>>> getUserHobbies(String userId) async {
    try {
      // Fetch hobby IDs for the current user
      QuerySnapshot userHobbiesSnapshot = await _firebaseService.firestore
          .collection('UserHobbies')
          .where('userId', isEqualTo: userId)
          .get();

      List<String> hobbyIds = userHobbiesSnapshot.docs
          .map((doc) => doc['interestId'] as String)
          .toList();

      // Fetch hobby details using the hobby IDs
      if (hobbyIds.isNotEmpty) {
        QuerySnapshot hobbiesSnapshot = await _firebaseService.firestore
            .collection('hobbies')
            .where(FieldPath.documentId, whereIn: hobbyIds)
            .get();

        List<Map<String, String>> userHobbies = hobbiesSnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'hobby': doc['hobby'] as String,
          };
        }).toList();

        return userHobbies;
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching user hobbies: $e");
      return [];
    }
  }

  Future<List<String>> getUserHobbies2(String userId) async {
    try {
      QuerySnapshot snapshot = await _firebaseService.firestore
          .collection('userHobbies')
          .where('userId', isEqualTo: userId)
          .get();

      List<String> hobbyIds = snapshot.docs.map((doc) => doc['hobbyId'] as String).toList();
      return hobbyIds;
    } catch (e) {
      print('Error fetching user hobbies: $e');
      throw e; // You can handle errors as needed
    }
  }

  Future<List<String>> getUsersByHobby(String hobbyId) async {
    try {
      QuerySnapshot snapshot = await _firebaseService.firestore
          .collection('userHobbies')
          .where('hobbyId', isEqualTo: hobbyId)
          .get();

      List<String> userIds = snapshot.docs.map((doc) => doc['userId'] as String).toList();
      return userIds;
    } catch (e) {
      print('Error fetching users by hobby: $e');
      throw e; // You can handle errors as needed
    }
  }

  Future<List<String>> getCommonUsers(List<String> hobbyIds) async {
    try {
      QuerySnapshot snapshot = await _firebaseService.firestore
          .collection('userHobbies')
          .where('hobbyId', whereIn: hobbyIds)
          .get();

      List<String> userIds = snapshot.docs.map((doc) => doc['userId'] as String).toList();

      // Filter out duplicate userIds
      userIds = userIds.toSet().toList();

      return userIds;
    } catch (e) {
      print('Error fetching common users: $e');
      throw e; // You can handle errors as needed
    }
  }
}
