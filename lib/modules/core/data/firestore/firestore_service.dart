import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safemoon_burn_ads/modules/core/data/firestore/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return _db
        .collection("users")
        .orderBy('score', descending: true)
        .snapshots();
  }

  Future<bool> updateUserScore(User user) async {
    return await _db
        .collection('users')
        .where('name', isEqualTo: user.name)
        .where('password', isEqualTo: user.password)
        .get()
        .then((data) {
      if (data.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(data.docs.first.id)
            .update({'score': user.score});
        return true;
      } else {
        return false;
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserScore(User user) {
    return _db
        .collection('users')
        .where('name', isEqualTo: user.name)
        .where('password', isEqualTo: user.password)
        .snapshots();
  }

  Future<bool> createUser(User user) async {
    try {
      await _db
          .collection('users')
          .where('name', isEqualTo: user.name)
          .where('password', isEqualTo: user.password)
          .get()
          .then((data) {
        if (data.docs.isNotEmpty) {
          return false;
        } else {
          _db.collection('users').add({
            'name': user.name,
            'password': user.password,
            'score': user.score,
          });
          return true;
        }
      });
    } catch (e) {
      print(e);
    }
    return false;
  }
}
