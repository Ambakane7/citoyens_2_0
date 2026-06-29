import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:flutter/material.dart';

class ConditionUtilisation extends StatelessWidget {
  const ConditionUtilisation({super.key});

  Widget buildConditionItem({
    required String title,
    required String content,
    required IconData icon,
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
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
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
          "CONDITIONS D'UTILISATION",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
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
                      "Conditions Générales d'Utilisation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "En utilisant l'application Citoyens 2.0, vous acceptez les présentes conditions d'utilisation. Nous vous invitons à les consulter attentivement afin de garantir une utilisation responsable et respectueuse de la plateforme.",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              buildSectionTitle("Conditions"),

              buildConditionItem(
                icon: Icons.flag,
                title: "1. Objectif de l'application",
                content:
                "L’Application Citoyens 2.0, développée par l’Association Women Tech Mali (WTM) avec le soutien du Ministère des Affaires Étrangères du Danemark (DANIDA) à travers le Fonds d’Appui aux Moteurs du Changement (FAMOC II), a pour objectif de faciliter l’engagement citoyen et l’accès à des informations fiables grâce au numérique. Elle permet aux utilisateurs de signaler des incidents locaux dans différents secteurs (Éducation, Santé, Infrastructures, Sécurité etc.) et d’accéder à des informations institutionnelles certifiées. En utilisant cette application, vous acceptez les présentes conditions d’Utilisation.",
              ),

              buildConditionItem(
                icon: Icons.rule,
                title: "2. Règles d'utilisation et de signalement",
                content:
                "Le citoyen s'engage à utiliser l'application de manière responsable.\n\n"
                    "Lors de la création d'un signalement, l'utilisateur s'engage à :\n\n"
                    "• Fournir des informations exactes et véridiques.\n\n"
                    "• Ne pas publier de photos ou de textes à caractère diffamatoire, injurieux, obscène, violent ou incitant à la haine.\n\n"
                    "• Respecter la vie privée d'autrui en évitant de photographier des visages identifiables ou des plaques d'immatriculation sans nécessité absolue.",
              ),

              buildConditionItem(
                icon: Icons.gavel,
                title: "3. Modération et suppression de contenu",
                content:
                "Toutes les requêtes envoyées via l'Application Citoyens 2.0 sont soumises à une modération par les équipes de Women Tech Mali avant leur transmission aux autorités compétentes ou leur publication.\n\n"
                    "WTM se réserve le droit de rejeter, masquer ou supprimer tout signalement considéré comme abusif, faux ou contraire aux présentes règles.\n\n"
                    "Le compte d'un utilisateur pourra être suspendu après trois (3) avertissements.",
              ),

              buildConditionItem(
                icon: Icons.security,
                title: "4. Anonymat et protection des données",
                content:
                "Les utilisateurs peuvent effectuer des signalements de manière anonyme. Dans ce cas, leur identité n'est pas divulguée aux autorités.\n\n"
                    "Les données personnelles sont traitées conformément aux directives de l'Autorité de Protection des Données à Caractère Personnel (APDP) du Mali.\n\n"
                    "Pour plus d'informations, veuillez consulter notre Politique de Confidentialité.",
              ),

              buildConditionItem(
                icon: Icons.balance,
                title: "5. Limite de responsabilité",
                content:
                "Women Tech Mali agit comme facilitateur technologique et intermédiaire entre les citoyens et les autorités.\n\n"
                    "WTM s'engage à transmettre les signalements validés aux services compétents mais ne peut être tenue responsable de la non-résolution matérielle du problème signalé ni des délais d'intervention, qui relèvent exclusivement des autorités locales ou des services techniques concernés.",
              ),

              buildConditionItem(
                icon: Icons.update,
                title: "6. Modification de l'application et des conditions",
                content:
                "Women Tech Mali se réserve le droit de modifier, mettre à jour ou suspendre l'application pour des raisons de maintenance, d'amélioration ou d'ajout de nouvelles fonctionnalités.\n\n"
                    "Les présentes Conditions Générales d'Utilisation peuvent également être modifiées à tout moment. Les utilisateurs seront informés des mises à jour majeures.",
              ),

              const SizedBox(height: 25),

              Card(
                color: Colors.green.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.green,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "L'utilisation continue de l'application après une mise à jour des conditions vaut acceptation des nouvelles dispositions.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
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

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}