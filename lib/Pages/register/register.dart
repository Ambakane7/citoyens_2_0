import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:womentech/Pages/login/login.dart';

import '../../auth/auth_service.dart';
import '../../component/my_button.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool isLoading = false;

  String? selectedProfile;

  final List<String> profiles = const [
    "Média",
    "Journaliste",
    "Agent de mairie",
    "Citoyen",
  ];

  Future<void> register() async {
    setState(() => isLoading = true);

    try {
      final authService = AuthService();

      final email = emailController.text.trim().isEmpty
          ? "user_${phoneController.text}@app.com"
          : emailController.text.trim();

      final userCredential = await authService.signUpWithEmailPassword(
        email,
        passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': email,
        'profile': selectedProfile,
      });

    } catch (e) {
      print(e);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// ================= HEADER =================
              _buildHeader(),

              const SizedBox(height: 20),

              _field(firstNameController, "Prénom"),
              _field(lastNameController, "Nom"),
              _field(phoneController, "Téléphone"),
              _field(emailController, "Email"),

              /// PROFILE
              Padding(
                padding: const EdgeInsets.all(20),
                child: DropdownButtonFormField<String>(
                  value: selectedProfile,
                  items: profiles
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedProfile = val),
                  decoration: const InputDecoration(
                    hintText: "Choisir profil",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              /// PASSWORD
              _passwordField(passwordController, "Mot de passe", true),

              /// CONFIRM
              _passwordField(confirmPasswordController, "Confirmer mot de passe", false),

              const SizedBox(height: 20),

              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                text: "S'inscrire",
                onTap: register,
              ),

              const SizedBox(height: 10),

              /// LOGIN REDIRECT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("J'ai déjà un compte"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    },
                    child: const Text(
                      " se connecter",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER AVEC LOGO =================
  Widget _buildHeader() {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// LOGO
          SizedBox(
            height: 110,
            child: Image.asset(
              'lib/images/logo original .png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),

          const SizedBox(height: 5),

          /// TEXTE
          const Text(
            "Inscription",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= INPUT =================
  Widget _field(TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ================= PASSWORD =================
  Widget _passwordField(TextEditingController c, String hint, bool isMain) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: c,
        obscureText: isMain ? _obscurePassword : _obscureConfirm,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              (isMain ? _obscurePassword : _obscureConfirm)
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                if (isMain) {
                  _obscurePassword = !_obscurePassword;
                } else {
                  _obscureConfirm = !_obscureConfirm;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}