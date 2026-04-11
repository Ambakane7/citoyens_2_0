import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Firebase instances
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===== CURRENT USER =====
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // ===== SIGN IN WITH EMAIL =====
  Future<UserCredential> signInWithEmailPassword(
      String email,
      String password,
      ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // ===== SIGN UP =====
  Future<UserCredential> signUpWithEmailPassword(
      String email,
      String password,
      ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // ===== PHONE → EMAIL (CLÉ DU SYSTEME) =====
  Future<String?> getEmailFromPhone(String phone) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return null;
      }

      return query.docs.first['email'];
    } catch (e) {
      throw Exception("phone_lookup_failed");
    }
  }

  // ===== SIGN OUT =====
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
