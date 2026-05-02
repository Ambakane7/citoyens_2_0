import 'package:CITOYENS_2_0/homepage/homepage.dart';
import 'package:flutter/material.dart';


import '../../auth/auth_service.dart';
import '../../component/my_button.dart';
import '../homepage.dart';
import '../register/register.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // ================= CONTROLLERS =================
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _obscurePassword = true;

  // ================= LOGIN =================
  Future<void> login() async {
    final identifier = identifierController.text.trim();
    final password = passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      showError("Veuillez remplir tous les champs.");
      return;
    }

    try {
      String emailToUse;

      if (identifier.contains('@')) {
        emailToUse = identifier;
      } else {
        final phone = identifier.startsWith('+')
            ? identifier
            : '+223$identifier';

        final email = await _authService.getEmailFromPhone(phone);

        if (email == null) {
          showError("Aucun compte associé à ce numéro.");
          return;
        }

        emailToUse = email;
      }

      await _authService.signInWithEmailPassword(
        emailToUse,
        password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Homepage()),
      );

    } catch (e) {
      showError("Identifiants incorrects.");
    }
  }

  // ================= ERROR =================
  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(message),
      ),
    );
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              _buildHeader(),

              const SizedBox(height: 40),

              /// IDENTIFIER
              _buildIdentifierField(),

              const SizedBox(height: 15),

              /// PASSWORD
              _buildPasswordField(),

              const SizedBox(height: 25),

              /// LOGIN BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: MyButton(
                  text: "Se connecter",
                  onTap: login,
                ),
              ),

              const SizedBox(height: 20),

              /// REGISTER
              _buildRegisterSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      height: 190, // 🔥 plus grand
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

          /// IMAGE (plus grande + visible)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: 90,
              child: Image.asset(
                'lib/images/logo original .png',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),

          const SizedBox(height: 5), // 🔥 rapproché

          /// TEXTE
          const Text(
            "Connexion",
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

  // ================= IDENTIFIER =================
  Widget _buildIdentifierField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: identifierController,
        decoration: InputDecoration(
          hintText: "Email ou téléphone",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ================= PASSWORD =================
  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: "Mot de passe",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),
    );
  }

  // ================= REGISTER =================
  Widget _buildRegisterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Pas de compte ? "),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            );
          },
          child: const Text(
            "Créer un compte",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}