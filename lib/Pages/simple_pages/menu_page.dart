import 'dart:convert';

import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../actupage.dart';
import '../../homepage/homepage.dart';
import '../allsignal.dart';
import '../login/login.dart';
import 'a_propos.dart';
import 'condition_utilisation.dart';
import 'contact.dart';
import 'editprofilpage.dart';
import 'foire_question.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  final Stream<User?> authStream =
  FirebaseAuth.instance.authStateChanges();

  final ImagePicker _picker = ImagePicker();

  bool isUploading = false;

  /// 📸 PHOTO PROFIL
  Future<void> _pickAndUploadProfileImage() async {

    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    try {

      /// 📂 OUVRIR GALERIE
      final picked =
      await _picker.pickImage(

        source: ImageSource.gallery,

        imageQuality: 60,

        maxWidth: 800,
        maxHeight: 800,
      );

      if (picked == null) return;

      setState(() {
        isUploading = true;
      });

      /// ☁️ IMGBB
      final request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          'https://api.imgbb.com/1/upload?key=1b4ae520694299b686da2c9323dbc0d6',
        ),
      );

      final bytes =
      await picked.readAsBytes();

      request.files.add(

        http.MultipartFile.fromBytes(
          'image',
          bytes,

          filename:
          picked.name,
        ),
      );

      final response =
      await request.send();

      final responseData =
      await response.stream
          .bytesToString();

      final jsonData =
      jsonDecode(responseData);

      if (response.statusCode == 200) {

        final imageUrl =
        jsonData['data']['url'];

        /// 🔥 FIRESTORE
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({

          "photoUrl": imageUrl,

        }, SetOptions(merge: true));

        if (!mounted) return;

        setState(() {});

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Photo de profil mise à jour",
            ),
          ),
        );

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Erreur upload image",
            ),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Erreur : $e",
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: StreamBuilder<User?>(
        stream: authStream,

        builder: (context, authSnapshot) {

          final user = authSnapshot.data;

          return SingleChildScrollView(

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                /// ================= HEADER =================
                Container(
                  width: double.infinity,
                  height: 220,

                  padding:
                  const EdgeInsets.all(16),

                  decoration:
                  const BoxDecoration(
                    color: Colors.green,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const SizedBox(height: 10),

                      const CustomBackButton(),

                      const SizedBox(height: 10),

                      Row(
                        children: [

                          /// 📸 PHOTO PROFIL
                          FutureBuilder<DocumentSnapshot>(

                            future: user == null
                                ? null
                                : FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .get(),

                            builder:
                                (context, snapshot) {

                              String? photoUrl;

                              if (snapshot.hasData &&
                                  snapshot.data!.exists) {

                                final data =
                                snapshot.data!.data()
                                as Map<String, dynamic>?;

                                photoUrl =
                                data?['photoUrl'];
                              }

                              return InkWell(

                                borderRadius:
                                BorderRadius.circular(100),

                                onTap: user == null
                                    ? null
                                    : _pickAndUploadProfileImage,

                                child: SizedBox(
                                  width: 70,
                                  height: 70,

                                  child: Stack(
                                    alignment:
                                    Alignment.center,

                                    children: [

                                      /// 👤 AVATAR
                                      CircleAvatar(
                                        radius: 30,

                                        backgroundColor:
                                        Colors.grey.shade300,

                                        backgroundImage:
                                        photoUrl != null
                                            ? NetworkImage(
                                          photoUrl,
                                        )
                                            : null,

                                        child:
                                        photoUrl == null

                                            ? const Icon(
                                          Icons.person,
                                          size: 30,
                                          color:
                                          Colors.black,
                                        )

                                            : null,
                                      ),

                                      /// 📷 CAMERA
                                      Positioned(
                                        bottom: 0,
                                        right: 0,

                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(
                                            4,
                                          ),

                                          decoration:
                                          const BoxDecoration(
                                            color:
                                            Colors.orange,

                                            shape:
                                            BoxShape.circle,
                                          ),

                                          child: const Icon(
                                            Icons.camera_alt,

                                            size: 16,

                                            color:
                                            Colors.white,
                                          ),
                                        ),
                                      ),

                                      /// 🔄 LOADING
                                      if (isUploading)

                                        Container(
                                          width: 60,
                                          height: 60,

                                          decoration:
                                          BoxDecoration(
                                            color:
                                            Colors.black38,

                                            borderRadius:
                                            BorderRadius.circular(
                                              100,
                                            ),
                                          ),

                                          child:
                                          const Center(
                                            child:
                                            CircularProgressIndicator(
                                              color:
                                              Colors.white,
                                              strokeWidth:
                                              2,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 12),

                          /// 🔥 USER INFO
                          Expanded(
                            child: user == null

                                ? const Text(
                              "Non connecté",

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            )

                                : FutureBuilder<DocumentSnapshot>(

                              future:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .get(),

                              builder:
                                  (context, snapshot) {

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {

                                  return const Text(
                                    "Chargement...",

                                    style: TextStyle(
                                      color:
                                      Colors.white,
                                    ),
                                  );
                                }

                                Map<String, dynamic>? data =
                                snapshot.data?.data()
                                as Map<String, dynamic>?;

                                String firstName =
                                    data?['firstName']
                                        ?.toString() ??
                                        "";

                                String lastName =
                                    data?['lastName']
                                        ?.toString() ??
                                        "";

                                String fullName =
                                "${firstName.trim()} ${lastName.trim()}"
                                    .trim();

                                return GestureDetector(

                                  onTap: () {

                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const EditProfilePage(),
                                      ),
                                    );
                                  },

                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children: [

                                      Text(
                                        fullName.isEmpty
                                            ? "Utilisateur"
                                            : fullName,

                                        style: const TextStyle(
                                          color:
                                          Colors.white,

                                          fontSize: 30,
                                        ),
                                      ),

                                      Text(
                                        user.email ??
                                            "Email non disponible",

                                        style:
                                        const TextStyle(
                                          color:
                                          Colors.white70,

                                          fontSize: 13,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 4,
                                      ),

                                      const Text(
                                        "Modifier les informations personnelles",

                                        style: TextStyle(
                                          color:
                                          Colors.white70,

                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// ================= MENU =================

                menuButton(
                  context,
                  Icons.home_outlined,
                  "Accueil",

                      () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const Homepage(),
                      ),
                    );
                  },
                ),

                menuButton(
                  context,
                  Icons.report_problem_outlined,
                  "Tous les signalements",

                      () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const AllSignalement(),
                      ),
                    );
                  },
                ),

                menuButton(
                  context,
                  Icons.info_outline,
                  "Actualité",

                      () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const ActuPage(),
                      ),
                    );
                  },
                ),

                menuButton(
                  context,
                  Icons.info_outline,
                  "À propos",

                      () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const Apropos(),
                      ),
                    );
                  },
                ),

                menuButton(
                  context,
                  Icons.help_outline,
                  "Foire aux questions",

                      () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const FoireQuestion(),
                      ),
                    );
                  },
                ),

                menuButton(
                  context,
                  Icons.description_outlined,
                  "Conditions d'utilisation",

                      () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const ConditionUtilisation(),
                      ),
                    );
                  },
                ),

                menuButton(
                  context,
                  Icons.contact_mail_outlined,
                  "Contact",

                      () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const Contact(),
                      ),
                    );
                  },
                ),

                /// 🔐 LOGIN / LOGOUT
                user == null

                    ? menuButton(
                  context,
                  Icons.login,
                  "Se connecter",

                      () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const LoginPage(),
                      ),
                    );
                  },
                )

                    : menuButton(
                  context,
                  Icons.logout,
                  "Déconnexion",

                      () async {

                    await FirebaseAuth.instance
                        .signOut();

                    Navigator.pushAndRemoveUntil(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const LoginPage(),
                      ),

                          (route) => false,
                    );
                  },
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding:
                  EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: Row(
                    children: [

                      Text("Version "),

                      Text(
                        "1.0.1",

                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ✅ MENU BUTTON
Widget menuButton(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
    ) {

  return Card(

    margin:
    const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),

    child: ListTile(

      leading: Icon(icon),

      title: Text(
        title,

        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),

      onTap: onTap,
    ),
  );
}