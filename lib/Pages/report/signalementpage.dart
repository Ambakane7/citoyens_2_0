import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart'; // ✅ AJOUT
import 'package:womentech/Pages/allsignal.dart';

import 'package:womentech/Pages/report/SignalementItem.dart';
import '../simple_pages/menu_page.dart';

// 🔽 DATA
import '../../data/categorie_data.dart';
import '../../models/model_categorie.dart' as models;
import '../../widget/type_selector.dart';

class Signalement extends StatefulWidget {
  const Signalement({super.key});

  @override
  State<Signalement> createState() => _SignalementState();
}

class _SignalementState extends State<Signalement> {
  LatLng? _selectedPosition;
  bool _isLoadingLocation = true;

  models.Category? selectedCategory;
  String? selectedSubCategory;
  final TextEditingController _commentController = TextEditingController();

  final ImagePicker _picker = ImagePicker(); // ✅ AJOUT
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _detectUserLocation();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// 📍 Localisation utilisateur
  Future<void> _detectUserLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showError("Veuillez activer la localisation");
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _showError("Autorisation localisation refusée");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });
    } catch (_) {
      _showError("Erreur lors de la récupération de la position");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() => _isLoadingLocation = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// 📸 Sélection image
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (picked != null && mounted) {
        setState(() => _image = picked);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la sélection de l’image")),
      );
    }
  }
  // Publication en mode anonyme ou avec son identité
  bool _isAnonymous = true; // par défaut : anonyme
  void _showIdentityChoice() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_off),
              title: const Text("Publier en mode anonyme"),
              trailing: _isAnonymous
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                setState(() => _isAnonymous = true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Publier avec mon identité"),
              trailing: !_isAnonymous
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                setState(() => _isAnonymous = false);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoadingLocation || _selectedPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    String _formatLatLng(LatLng position) {
      return "${position.latitude.toStringAsFixed(6)}, "
          "${position.longitude.toStringAsFixed(6)}";
    }
    Future<Map<String, String>> _getUserIdentity() async {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return {
          "firstName": "",
          "lastName": "",
          "authorType": "anonymous",
        };
      }

      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!snap.exists) {
        return {
          "firstName": "",
          "lastName": "",
          "authorType": "anonymous",
        };
      }

      final data = snap.data()!;

      return {
        "firstName": data['firstName'] ?? "",
        "lastName": data['lastName'] ?? "",
        "authorType": "me",
      };
    }
    Future<void> _submitSignalement() async {
      if (selectedCategory == null ||
          _commentController.text.trim().isEmpty ||
          _selectedPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Champs obligatoires manquants")),
        );
        return;
      }

      try {
        String firstName = "";
        String lastName = "";
        String authorType = "anonymous";

        // 🔐 Récupération identité seulement si non anonyme
        if (!_isAnonymous) {
          final identity = await _getUserIdentity();
          firstName = identity['firstName']!;
          lastName = identity['lastName']!;
          authorType = identity['authorType']!;
        }

        await FirebaseFirestore.instance.collection('signalements').add({
          // 📍 Localisation
          "latitude": _selectedPosition!.latitude,
          "longitude": _selectedPosition!.longitude,

          // 🗂️ Catégories
          "category": selectedCategory!.name,
          "subCategory": selectedSubCategory ?? "",

          // 💬 Contenu
          "comment": _commentController.text.trim(),

          // 📌 Statut
          "status": "en_cours",

          // 👤 Auteur
          "authorType": authorType,
          "firstName": firstName,
          "lastName": lastName,

          // 🕒 Date
          "createdAt": FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signalement publié avec succès")),
        );

        Navigator.push(context, MaterialPageRoute(builder: (context)=>AllSignalement()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la publication")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Image.asset("lib/images/no_bg.png"),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          /// 🗺️ MAP
          FlutterMap(
            options: MapOptions(
              initialCenter: _selectedPosition!,
              initialZoom: 18,
              onTap: (_, latLng) =>
                  setState(() => _selectedPosition = latLng),
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.citoyen.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedPosition!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// 🔽 PANNEAU BAS
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(40),
                color: Colors.transparent,
                child: Column(
                  children: [
                    SignalementItem(
                      icon: Icons.location_on_outlined,
                      label: _selectedPosition == null
                          ? "Localisation indisponible"
                          : _formatLatLng(_selectedPosition!),
                      onTap: () {
                        // Optionnel : centrer la carte ou ouvrir un détail plus tard
                      },
                    ),

                    SizedBox(height: 7,),
                    SignalementItem(
                      icon: Icons.category_outlined,
                      label: selectedCategory == null
                          ? "Sélectionner une catégorie"
                          : selectedSubCategory == null || selectedSubCategory!.isEmpty
                          ? selectedCategory!.name
                          : "${selectedCategory!.name} > $selectedSubCategory",
                      onTap: () async {
                        final result = await showTypeSelectorBottomSheet(
                          context: context,
                          categories: categories,
                        );
                        if (result != null && mounted) {
                          setState(() {
                            selectedCategory = result['category'];
                            selectedSubCategory = result['subCategory'];
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    SignalementItem(
                      icon: _isAnonymous ? Icons.visibility_off : Icons.person,
                      label: _isAnonymous
                          ? "Publication : Anonyme"
                          : "Publication : Avec mon identité",
                      onTap: _showIdentityChoice,
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _commentController,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.black, // ✏️ TEXTE SAISI
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Décrivez le problème...",
                          hintStyle: TextStyle(
                            color: Colors.black54, // 👻 PLACEHOLDER
                          ),
                          border: InputBorder.none, // ❌ pas de bordure interne
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _pickImage(ImageSource.camera),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 32,
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Caméra",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => _pickImage(ImageSource.gallery),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.photo_library,
                                    size: 32,
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Galerie",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),


                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          if (selectedCategory == null ||
                              _commentController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Catégorie et commentaire requis"),
                              ),
                            );
                            return;
                          }

                          // ✅ APPEL PROPRE
                          _submitSignalement();
                        },
                        child: const Text(
                          "Signaler le problème",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
