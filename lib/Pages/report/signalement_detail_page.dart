import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignalementDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const SignalementDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    final date = data['createdAt'] != null
        ? DateFormat("dd MMM yyyy - HH:mm")
        .format(data['createdAt'].toDate())
        : "Date inconnue";

    final bool isAnonymous = data['authorType'] == "anonymous";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail du signalement", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITRE
            Text(
              (data['category'] ?? "Non défini").toString(),
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              (data['subCategory'] ?? "").toString(),
            ),

            const SizedBox(height: 20),

            /// BADGES
            Row(
              children: [
                _badge(
                  (data['severity'] ?? "Faible").toString(),
                  Colors.red,
                ),
                const SizedBox(width: 10),
                _badge(
                  data['status'] == "en_cours"
                      ? "En cours"
                      : "Traité",
                  data['status'] == "en_cours"
                      ? Colors.orange
                      : Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// DESCRIPTION
            _section("Description", data['comment']),

            /// LOCALISATION
            _section(
              "Localisation",
              "Latitude: ${data['latitude'] ?? ""}\nLongitude: ${data['longitude'] ?? ""}",
            ),

            /// UTILISATEUR
            _section(
              "Auteur",
              isAnonymous
                  ? "Anonyme"
                  : "${data['firstName'] ?? ""} ${data['lastName'] ?? ""}",
            ),

            /// DATE
            _section("Date de publication", date),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text((value ?? "").toString()), // 🔥 FIX ICI
          )
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}