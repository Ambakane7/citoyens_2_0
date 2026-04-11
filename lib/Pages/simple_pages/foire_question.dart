import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FoireQuestion extends StatefulWidget {
  const FoireQuestion({super.key});

  @override
  State<FoireQuestion> createState() => _FoireQuestionState();
}

class _FoireQuestionState extends State<FoireQuestion> {

  final TextEditingController questionController = TextEditingController();

  /// 📩 ENVOI EMAIL
  Future<void> sendEmail() async {
    final question = questionController.text.trim();

    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez écrire une question")),
      );
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'contact@citoyen.ml',
      query: Uri.encodeFull(
        'subject=Question utilisateur CITOYEN 2.0&body=$question',
      ),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir l'application mail")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "Foire aux questions",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 QUESTION FAQ
              const Text(
                "1. C'est quoi CITOYEN 2.0 ?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              /// 🔹 RÉPONSE
              const Text(
                "CITOYEN 2.0 est une application permettant aux citoyens de signaler des problèmes dans leur zone afin d'améliorer leur environnement.",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 30),

              /// 🔹 INPUT
              const Text(
                "Posez votre question",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: questionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Écrivez votre question ici...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 BOUTON ENVOI
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: sendEmail,
                  child: const Text(
                    "Envoyer",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}