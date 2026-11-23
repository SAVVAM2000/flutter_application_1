import 'package:cloud_firestore/cloud_firestore.dart';

/// Профиль пользователя, который хранится в Cloud Firestore.
class UserProfile {
  const UserProfile({required this.email, required this.createdAt});

  final String email;
  final DateTime createdAt;
}

/// Работа с коллекцией users в Cloud Firestore.
class UserStore {
  UserStore(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> saveProfile({required String uid, required String email}) {
    return _firestore.collection('users').doc(uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserProfile?> readProfile(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    final created = data['createdAt'];
    return UserProfile(
      email: data['email'] as String? ?? '',
      createdAt: created is Timestamp ? created.toDate() : DateTime.now(),
    );
  }
}
