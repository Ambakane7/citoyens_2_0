import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final user = FirebaseAuth.instance.currentUser;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final data = doc.data();

    firstNameController.text = data?['firstName'] ?? '';
    lastNameController.text = data?['lastName'] ?? '';
    phoneController.text = data?['phone'] ?? '';

    setState(() => isLoading = false);
  }

  Future<void> updateUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'phone': phoneController.text.trim(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier profil"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: "Prénom"),
            ),

            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Téléphone"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: updateUser,
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}