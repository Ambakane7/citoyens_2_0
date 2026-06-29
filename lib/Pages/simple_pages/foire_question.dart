import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FoireQuestion extends StatefulWidget {
  const FoireQuestion({super.key});

  @override
  State<FoireQuestion> createState() => _FoireQuestionState();
}

class _FoireQuestionState extends State<FoireQuestion> {
  final TextEditingController questionController = TextEditingController();

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }

  /// 📩 Envoi de la question par email
  Future<void> sendEmail() async {
    final question = questionController.text.trim();

    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez écrire une question."),
        ),
      );
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'contact@womentech.ml',
      query: Uri.encodeFull(
        'subject=Question utilisateur Citoyens 2.0&body=$question',
      ),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Impossible d'ouvrir l'application de messagerie.",
          ),
        ),
      );
    }
  }

  Widget buildFaqItem({
    required String question,
    required String answer,
    IconData icon = Icons.help_outline,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: Colors.green,
        ),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: const CustomBackButton(),
        actions: const [
          CustomMenuButton(),
        ],
        title: const Text(
          "FOIRE AUX QUESTIONS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(2, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Introduction
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.green.shade200,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Foire aux questions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Retrouvez ici les réponses aux questions les plus fréquemment posées concernant l'utilisation de l'application Citoyens 2.0.",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              buildSectionTitle("Questions fréquentes"),

              buildFaqItem(
                icon: Icons.report_problem,
                question:
                "Comment faire un signalement sur l'application ?",
                answer:
                "Cliquez sur le bouton « Signaler », prenez une photo du problème (assainissement, lampadaire en panne, fuite d'eau, etc.), choisissez la catégorie correspondante, ajoutez une description puis validez. Votre position géolocalisée sera automatiquement jointe afin d'aider les services compétents à identifier rapidement le lieu exact.",
              ),

              buildFaqItem(
                icon: Icons.visibility_off,
                question:
                "Puis-je faire un signalement de manière anonyme ?",
                answer:
                "Oui, absolument. Lors de la création de votre requête, vous pouvez cocher l'option « Signaler de manière anonyme ». Votre identité sera alors masquée et ne sera visible ni dans les signalements publics ni auprès des autorités en charge du traitement.",
              ),

              buildFaqItem(
                icon: Icons.account_balance,
                question:
                "Qui reçoit et traite mes requêtes ?",
                answer:
                "Une fois envoyé, votre signalement est reçu sur la plateforme d'administration gérée par Women Tech Mali. Après vérification afin d'éviter les abus et les fausses alertes, il est transmis aux autorités locales ou aux services techniques compétents.",
              ),

              buildFaqItem(
                icon: Icons.track_changes,
                question:
                "Comment savoir si mon problème a été pris en compte ?",
                answer:
                "Dans l'espace « Mes signalements », vous pouvez suivre l'évolution de vos requêtes grâce aux différents statuts :\n\n"
                    "• Reçu : votre signalement a bien été enregistré.\n\n"
                    "• En cours : le problème a été transmis aux autorités compétentes.\n\n"
                    "• Résolu : l'intervention a été effectuée.\n\n"
                    "• Rejeté : le signalement n'a pas été validé (fausse alerte, doublon ou non-respect des règles d'utilisation).",
              ),

              buildFaqItem(
                icon: Icons.newspaper,
                question:
                "À quoi sert le fil d'actualité ?",
                answer:
                "Le fil d'actualité permet de lutter contre la désinformation en mettant à votre disposition des informations institutionnelles certifiées, des alertes fiables ainsi que des actualités concernant votre ville et votre communauté.",
              ),

              const SizedBox(height: 30),

              buildSectionTitle("Une autre question ?"),

              const Text(
                "Si vous ne trouvez pas la réponse à votre question, vous pouvez nous écrire directement. Notre équipe vous répondra dans les meilleurs délais.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: questionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Écrivez votre question ici...",
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.green.shade200,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: sendEmail,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Envoyer ma question",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Center(
                child: Text(
                  "Citoyens 2.0 • Women Tech Mali",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
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