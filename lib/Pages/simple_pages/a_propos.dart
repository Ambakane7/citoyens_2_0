import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Apropos extends StatelessWidget {
  const Apropos({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Impossible d'ouvrir $url");
    }
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

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    Color color = Colors.green,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
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
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLinkCard({
    required String text,
    required String url,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchUrl(url),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.green,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.open_in_new,
                color: Colors.grey,
              ),
            ],
          ),
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
          "À PROPOS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// INTRODUCTION
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
                      "Bienvenue sur Citoyens 2.0",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "L'application mobile qui place le citoyen au cœur du développement de sa communauté.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              buildInfoCard(
                icon: Icons.lightbulb,
                title: "Présentation",
                content:
                "Initiée par l'association Women Tech Mali (WTM), avec l'appui financier du Ministère des Affaires Étrangères du Danemark (DANIDA) à travers le Fonds d'Appui aux Moteurs du Changement (FAMOC), l'Application Citoyens 2.0 est un outil numérique innovant conçu pour faciliter le dialogue entre les populations et les autorités nationales.\n\n"
                    "Votre voix, votre quartier, votre ville, notre souci !",
              ),

              const SizedBox(height: 20),

              buildSectionTitle("Notre mission"),

              buildInfoCard(
                icon: Icons.flag,
                title: "Objectif 1",
                content:
                "Faciliter la remontée d'informations sur les problèmes du quotidien (Éducation, Santé, Infrastructure, Sécurité, etc.) afin de permettre une intervention plus rapide des services compétents.",
              ),

              buildInfoCard(
                icon: Icons.verified,
                title: "Objectif 2",
                content:
                "Lutter contre la désinformation en offrant un accès direct à des informations institutionnelles certifiées et fiables ainsi qu'à des articles de fact-checking.",
              ),

              const SizedBox(height: 20),

              buildSectionTitle("Fonctionnalités"),

              buildInfoCard(
                icon: Icons.report_problem,
                title: "Signaler un incident",
                content:
                "Prenez une photo, géolocalisez le problème et envoyez votre signalement même sans connexion internet.",
              ),

              buildInfoCard(
                icon: Icons.track_changes,
                title: "Suivre vos requêtes",
                content:
                "Restez informé de l'état d'avancement de vos signalements : Reçu, En cours ou Résolu.",
              ),

              buildInfoCard(
                icon: Icons.newspaper,
                title: "Vous informer",
                content:
                "Consultez les actualités vérifiées, les initiatives locales et les alertes importantes.",
              ),

              buildInfoCard(
                icon: Icons.poll,
                title: "Participer",
                content:
                "Donnez votre avis à travers des sondages pour orienter les décisions de votre commune.",
              ),

              const SizedBox(height: 20),

              buildSectionTitle("Engagement et sécurité"),

              buildInfoCard(
                icon: Icons.security,
                title: "Protection des données",
                content:
                "Votre confiance est notre priorité. L'application garantit la protection de vos données personnelles conformément aux directives de l'Autorité de Protection des Données à Caractère Personnel (APDP). Les signalements peuvent être traités en toute confidentialité.",
              ),

              const SizedBox(height: 20),

              buildSectionTitle("Nos partenaires"),

              buildInfoCard(
                icon: Icons.handshake,
                title: "Women Tech Mali & DANIDA/FAMOC",
                content:
                "Ce projet a été rendu possible grâce à l'engagement de Women Tech Mali, association œuvrant pour la promotion des TIC auprès des jeunes filles et des femmes, ainsi qu'au soutien technique et financier du DANIDA à travers le Fonds d'Appui aux Moteurs du Changement (FAMOC).",
              ),

              const SizedBox(height: 20),

              buildSectionTitle("Informations sur l'application"),

              buildInfoCard(
                icon: Icons.info,
                title: "Version",
                content: "1.0",
              ),

              buildInfoCard(
                icon: Icons.business,
                title: "Éditeur",
                content: "Women Tech Mali",
              ),

              buildInfoCard(
                icon: Icons.code,
                title: "Développement technique",
                content: "LAAWOL DEV",
              ),

              const SizedBox(height: 20),

              buildSectionTitle("Contact et site web"),

              buildLinkCard(
                text: "contact@womentech.ml",
                url: "mailto:contact@womentech.ml",
                icon: Icons.email,
              ),

              buildLinkCard(
                text: "www.womentech.ml",
                url: "https://www.womentech.ml",
                icon: Icons.language,
              ),

              const SizedBox(height: 25),

              Center(
                child: Text(
                  "Ensemble, construisons une citoyenneté active et responsable !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}