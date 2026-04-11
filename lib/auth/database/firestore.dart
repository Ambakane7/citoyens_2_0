import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer les infos du user connecté
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  //Sauvegarder la commande
  Future<void> saveOrderToDatabase(String receipt) async {
   final user = _auth.currentUser;
  if (user == null) return;

   final orderData = {
   'userId': user.uid,
  'receipt': receipt,
  'createdAt': FieldValue.serverTimestamp(),
  };

   await _firestore.collection('orders').add(orderData);
   }

}