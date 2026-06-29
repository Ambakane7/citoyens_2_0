import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Impossible d'ouvrir $url");
    }
  }

  Widget buildLink({
    required String text,
    required String url,
    required IconData icon,
    Color color = Colors.green,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchUrl(url),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(
                Icons.open_in_new,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
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
          "CONTACT",
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
              /// Message d'introduction
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
                      "Besoin d'assistance ?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Vous avez rencontré une difficulté technique avec l'application Citoyens 2.0 ? "
                          "Vous avez une suggestion d'amélioration ou souhaitez devenir partenaire du projet ?\n\n"
                          "L'équipe de Women Tech Mali est à votre écoute et s'efforcera de répondre à votre demande dans les meilleurs délais.",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// Coordonnées
              buildSectionTitle("Coordonnées"),

              buildLink(
                text: "contact@womentech.ml",
                url: "mailto:contact@womentech.ml",
                icon: Icons.email,
                color: Colors.red,
              ),

              buildLink(
                text: "+223 79 51 00 61",
                url: "tel:+22379510061",
                icon: Icons.phone,
              ),

              buildLink(
                text: "+223 72 55 09 81",
                url: "tel:+22372550981",
                icon: Icons.phone,
              ),

              buildLink(
                text: "+223 78 74 94 52",
                url: "tel:+22378749452",
                icon: Icons.phone,
              ),

              buildLink(
                text: "+223 44 51 04 64",
                url: "tel:+22344510464",
                icon: Icons.phone,
              ),

              buildLink(
                text: "Contacter via WhatsApp",
                url: "https://wa.me/22379510061",
                icon: Icons.chat,
                color: Colors.green,
              ),

              const SizedBox(height: 25),

              /// Adresse
              buildSectionTitle("Adresse"),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Djélibougou près du Lycée Kodonso,\nBamako, Mali",
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Réseaux sociaux
              buildSectionTitle("Réseaux sociaux"),

              buildLink(
                text: "Facebook",
                url: "https://www.facebook.com/WTMali?locale=fr_FR",
                icon: Icons.facebook,
                color: Colors.blue,
              ),

              buildLink(
                text: "LinkedIn",
                url:
                "https://www.linkedin.com/in/womentech-mali-08b167328/",
                icon: Icons.business_center,
                color: Colors.blue,
              ),

              buildLink(
                text: "Instagram",
                url:
                "https://www.instagram.com/women.techmali/?hl=en",
                icon: Icons.camera_alt,
                color: Colors.purple,
              ),

              buildLink(
                text: "YouTube",
                url:
                "https://www.youtube.com/@WomenTechMali-b6c/videos",
                icon: Icons.play_circle_fill,
                color: Colors.red,
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  "© ${DateTime.now().year} Women Tech Mali",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}