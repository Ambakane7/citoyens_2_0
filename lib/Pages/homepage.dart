import 'package:flutter/material.dart';
import 'package:womentech/homepage/homepage.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  String selectedLang = "fr";
  bool dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [

          /// ================= IMAGE FULL SCREEN =================
          Positioned.fill(
            child: Image.asset(
              'lib/images/2.png',
              fit: BoxFit.cover, // 🔥 prend tout l'écran
            ),
          ),

          /// ================= OVERLAY (optionnel pour lisibilité) =================
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          /// ================= CONTENU =================
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// TEXTE
                const Text(
                  "Veuillez choisir\n une langue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                /// BOUTONS LANGUE
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    /// FR
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedLang = "fr";
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedLang == "fr"
                              ? Colors.orange
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text(
                          "FR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedLang == "fr"
                                ? Colors.white
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    /// BA
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedLang = "ba";
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedLang == "ba"
                              ? Colors.orange
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text(
                          "BA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// CHECKBOX
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Checkbox(
                        value: dontShowAgain,
                        checkColor: Colors.black,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          setState(() {
                            dontShowAgain = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "Ne plus afficher au lancement de l'application",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ================= BOUTON OK =================
          Positioned(
            bottom: 85,
            left: 50,
            right: 50,
            child: SafeArea(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {

                    debugPrint("Langue choisie : $selectedLang");
                    debugPrint("Ne plus afficher : $dontShowAgain");

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Homepage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}