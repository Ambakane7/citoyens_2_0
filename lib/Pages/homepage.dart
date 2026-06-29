import 'package:CITOYENS_2_0/Pages/allsignal.dart';
import 'package:CITOYENS_2_0/Pages/report/signalementpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homepage/homepage.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  String selectedLang = "fr";
  bool dontShowAgain = false;

  /// ================= INIT =================
  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  /// ================= LOAD DATA =================
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      selectedLang = prefs.getString('selectedLang') ?? "fr";
      dontShowAgain = prefs.getBool('dontShowLanguagePage') ?? false;
    });
  }

  /// ================= SAVE DATA =================
  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('selectedLang', selectedLang);
    await prefs.setBool('dontShowLanguagePage', dontShowAgain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [

          /// ================= IMAGE =================
          Positioned.fill(
            child: Image.asset(
              'lib/images/2.png',
              fit: BoxFit.contain,
            ),
          ),

          /// ================= OVERLAY =================
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

                /// ================= LANGUES =================
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
                        child: const Text(
                          "FR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    /// BA
                    GestureDetector(
                      onTap: () {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.orange,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            content: const Text(
                              "La langue Bambara est en cours de développement",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );

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
                        child: const Text(
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

                /// ================= CHECKBOX =================
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
                            fontWeight: FontWeight.bold,
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
                  onPressed: () async {

                    await savePreferences();

                    debugPrint("Langue choisie : $selectedLang");
                    debugPrint("Ne plus afficher : $dontShowAgain");

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Homepage(),//Languagepage
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