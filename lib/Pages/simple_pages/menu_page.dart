import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:womentech/Pages/allsignal.dart';
import 'package:womentech/homepage/homepage.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: authStream,
        builder: (context, authSnapshot) {

          final user = authSnapshot.data;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ================= HEADER =================
                Container(
                  width: double.infinity,
                  height: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Colors.green),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [

                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 30),
                          ),

                          const SizedBox(width: 12),

                          /// 🔥 USER INFO
                          Expanded(
                            child: user == null
                                ? const Text(
                              "Non connecté",
                              style: TextStyle(color: Colors.white),
                            )
                                : FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .get(),
                              builder: (context, snapshot) {

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text(
                                    "Chargement...",
                                    style: TextStyle(color: Colors.white),
                                  );
                                }

                                /// 🔥 récupération sécurisée
                                Map<String, dynamic>? data =
                                snapshot.data?.data()
                                as Map<String, dynamic>?;

                                String firstName =
                                    data?['firstName']?.toString() ?? "";
                                String lastName =
                                    data?['lastName']?.toString() ?? "";

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

                                      /// ✅ NOM + PRENOM
                                      Text(
                                        fullName.isEmpty
                                            ? "Utilisateur"
                                            : fullName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),

                                      /// ✅ EMAIL
                                      Text(
                                        user.email ??
                                            "Email non disponible",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      const Text(
                                        "Modifier les informations personnelles",
                                        style: TextStyle(
                                          color: Colors.white70,
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

                menuButton(context, Icons.home_outlined, "Accueil", () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Homepage()),
                  );
                }),

                menuButton(context, Icons.report_problem_outlined,
                    "Tous les signalements", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AllSignalement()),
                      );
                    }),

                menuButton(context, Icons.info_outline, "À propos", () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const APropos()),
                  );
                }),

                menuButton(context, Icons.help_outline,
                    "Foire aux questions", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FoireQuestion()),
                      );
                    }),

                menuButton(context, Icons.description_outlined,
                    "Conditions d'utilisation", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ConditionUtilisation(),
                        ),
                      );
                    }),

                /// 🔐 LOGIN / LOGOUT
                user == null
                    ? menuButton(context, Icons.login, "Me connecter", () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                })
                    : menuButton(context, Icons.logout, "Déconnexion", () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                  );
                }),

                menuButton(context, Icons.contact_mail_outlined, "Contact", () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Contact()),
                  );
                }),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text("Version "),
                      Text("1.0.1",
                          style: TextStyle(color: Colors.orange)),
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

/// ✅ BOUTON MENU
Widget menuButton(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
    ) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    ),
  );
}