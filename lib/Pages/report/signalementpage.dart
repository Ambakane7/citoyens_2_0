import 'dart:convert';
import 'dart:io';

import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../allsignal.dart';
import '../login/login.dart';
import '../simple_pages/menu_page.dart';

/// 🔽 DATA
import '../../data/categorie_data.dart';
import '../../models/model_categorie.dart' as models;
import '../../widget/type_selector.dart';
import 'SignalementItem.dart';

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

  final TextEditingController _commentController =
  TextEditingController();

  final ImagePicker _picker = ImagePicker();

  /// 📸 PHOTOS
  List<XFile> _images = [];

  /// ☁️ URLS CLOUD
  List<String> uploadedImageUrls = [];

  bool isUploadingImage = false;

  /// 🔥 SEVERITE
  String? selectedSeverity;

  final List<String> severities = const [
    "Critique",
    "Grave",
    "Moyen",
    "Faible",
  ];

  /// 👤 ANONYME
  bool _isAnonymous = true;

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

  /// 📍 LOCALISATION
  Future<void> _detectUserLocation() async {

    try {

      if (!await Geolocator.isLocationServiceEnabled()) {

        _showError("Veuillez activer la localisation");

        return;
      }

      var permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {

        permission =
        await Geolocator.requestPermission();
      }

      if (permission ==
          LocationPermission.deniedForever) {

        _showError(
            "Autorisation localisation refusée");

        return;
      }

      final position =
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {

        _selectedPosition = LatLng(
          position.latitude,
          position.longitude,
        );

        _isLoadingLocation = false;
      });

    } catch (_) {

      _showError(
        "Erreur lors de la récupération de la position",
      );
    }
  }

  void _showError(String message) {

    if (!mounted) return;

    setState(() => _isLoadingLocation = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  /// 📸 PRENDRE PHOTO
  Future<void> _pickImage() async {

    if (_images.length >= 3) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Maximum 3 photos"),
        ),
      );

      return;
    }

    try {

      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 60,
      );

      if (picked != null && mounted) {

        setState(() {
          _images.add(picked);
        });

        await _uploadImageToImgBB(picked);
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Erreur lors de la prise de photo",
          ),
        ),
      );
    }
  }

  /// ☁️ UPLOAD IMGBB
  Future<void> _uploadImageToImgBB(
      XFile imageFile,
      ) async {

    setState(() {
      isUploadingImage = true;
    });

    try {

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.imgbb.com/1/upload?key=1b4ae520694299b686da2c9323dbc0d6',
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      final response = await request.send();

      final responseData =
      await response.stream.bytesToString();

      final jsonData = jsonDecode(responseData);

      if (response.statusCode == 200) {

        setState(() {

          uploadedImageUrls.add(
            jsonData['data']['url'],
          );

        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Photo uploadée",
            ),
          ),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Erreur upload image",
            ),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : $e"),
        ),
      );

    }

    setState(() {
      isUploadingImage = false;
    });
  }

  /// 👤 CHOIX IDENTITE
  void _showIdentityChoice() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Mode de publication",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.visibility_off,
                  color: Colors.green,
                ),
                title: const Text(
                  "Publier en mode anonyme",
                ),
                trailing: _isAnonymous
                    ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
                    : null,
                onTap: () {
                  setState(() {
                    _isAnonymous = true;
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                title: const Text(
                  "Publier avec mon identité",
                ),
                trailing: !_isAnonymous
                    ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
                    : null,
                onTap: () {
                  setState(() {
                    _isAnonymous = false;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 👤 IDENTITE USER
  Future<Map<String, String>>
  _getUserIdentity() async {

    final user =
        FirebaseAuth.instance.currentUser;

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

  /// 🚀 PUBLIER
  Future<void> _submitSignalement() async {

    /// 🔐 VERIFICATION CONNEXION
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Veuillez vous connecter pour effectuer un signalement",
          ),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );

      return;
    }

    /// ✅ VALIDATION CHAMPS
    if (selectedCategory == null ||
        _commentController.text.trim().isEmpty ||
        _selectedPosition == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("Champs obligatoires manquants"),
        ),
      );

      return;
    }

    /// 🔥 VALIDATION SEVERITE
    if (selectedSeverity == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Veuillez choisir un niveau de gravité",
          ),
        ),
      );

      return;
    }

    try {

      String firstName = "";
      String lastName = "";
      String authorType = "anonymous";

      /// 👤 IDENTITE SI NON ANONYME
      if (!_isAnonymous) {

        final identity =
        await _getUserIdentity();

        firstName = identity['firstName']!;
        lastName = identity['lastName']!;
        authorType = identity['authorType']!;
      }

      /// ☁️ FIRESTORE
      await FirebaseFirestore.instance
          .collection('signalements')
          .add({

        /// 📍 POSITION
        "latitude":
        _selectedPosition!.latitude,

        "longitude":
        _selectedPosition!.longitude,

        /// 🗂️ CATEGORIES
        "category":
        selectedCategory!.name,

        "subCategory":
        selectedSubCategory ?? "",

        /// 💬 CONTENU
        "comment":
        _commentController.text.trim(),

        /// 🔥 GRAVITE
        "severity":
        selectedSeverity ?? "Faible",

        /// 📌 STATUT
        "status": "en_cours",

        /// 👤 USER
        "uid": user.uid,

        "authorType": authorType,

        "firstName": firstName,

        "lastName": lastName,

        /// 📸 IMAGES
        "images": uploadedImageUrls,

        /// 🕒 DATE
        "createdAt":
        FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("Signalement publié avec succès"),
        ),
      );

      /// 🔄 REDIRECTION
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AllSignalement(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erreur lors de la publication : $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoadingLocation ||
        _selectedPosition == null) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    String _formatLatLng(LatLng position) {

      return "${position.latitude.toStringAsFixed(6)}, "
          "${position.longitude.toStringAsFixed(6)}";
    }

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,

        leading: const CustomBackButton(),

        centerTitle: true,

        title: const Text(
          "SIGNALEMENT",

          style: TextStyle(
            color: Colors.white,
            fontSize: 15,

            shadows: [
              Shadow(
                offset: Offset(3, 1),
                blurRadius: 2,
              )
            ],
          ),
        ),

        actions: const [
          CustomMenuButton()
        ],
      ),

      body: Stack(
        children: [

          FlutterMap(
            options: MapOptions(
              initialCenter: _selectedPosition!,
              initialZoom: 18,

              onTap: (_, latLng) =>
                  setState(() =>
                  _selectedPosition = latLng),
            ),

            children: [

              TileLayer(
                urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",

                userAgentPackageName:
                'com.citoyen.app',
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

          Positioned(
            top: MediaQuery.of(context).size.height * 0.30,
            left: 0,
            right: 0,
            bottom: 0,

            child: SingleChildScrollView(

              child: Container(
                padding:
                const EdgeInsets.all(40),

                color: Colors.transparent,

                child: Column(
                  children: [

                    SignalementItem(
                      icon:
                      Icons.location_on_outlined,

                      label:
                      _selectedPosition == null
                          ? "Localisation indisponible"
                          : _formatLatLng(
                        _selectedPosition!,
                      ),

                      onTap: () {},
                    ),

                    const SizedBox(height: 7),

                    SignalementItem(
                      icon:
                      Icons.category_outlined,

                      label: selectedCategory ==
                          null
                          ? "Sélectionner une catégorie"
                          : selectedSubCategory ==
                          null ||
                          selectedSubCategory!
                              .isEmpty
                          ? selectedCategory!.name
                          : "${selectedCategory!.name} > $selectedSubCategory",

                      onTap: () async {

                        final result =
                        await showTypeSelectorBottomSheet(
                          context: context,
                          categories: categories,
                        );

                        if (result != null &&
                            mounted) {

                          setState(() {

                            selectedCategory =
                            result['category'];

                            selectedSubCategory =
                            result['subCategory'];
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    SignalementItem(
                      icon: _isAnonymous
                          ? Icons.visibility_off
                          : Icons.person,

                      label: _isAnonymous
                          ? "Publication : Anonyme"
                          : "Publication : Avec mon identité",

                      onTap:
                      _showIdentityChoice,
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(12),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.1),

                            blurRadius: 6,

                            offset:
                            const Offset(0, 3),
                          ),
                        ],
                      ),

                      child: TextField(
                        controller:
                        _commentController,

                        maxLines: 3,

                        decoration:
                        const InputDecoration(
                          hintText:
                          "Décrivez le problème...",

                          border:
                          InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(12),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.1),

                            blurRadius: 6,

                            offset:
                            const Offset(0, 3),
                          ),
                        ],
                      ),

                      child:
                      DropdownButtonHideUnderline(

                        child:
                        DropdownButton<String>(

                          value:
                          selectedSeverity,

                          isExpanded: true,

                          hint: const Text(
                            "Niveau de gravité",
                          ),

                          items: severities.map((e) {

                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );

                          }).toList(),

                          onChanged: (val) {

                            setState(() {
                              selectedSeverity =
                                  val;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 📸 CAMERA
                    InkWell(
                      onTap: _pickImage,

                      borderRadius:
                      BorderRadius.circular(12),

                      child: Container(
                        height: 110,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(12),

                          boxShadow: [

                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1),

                              blurRadius: 6,

                              offset:
                              const Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [

                            const Icon(
                              Icons.camera_alt,
                              size: 32,
                              color: Colors.black,
                            ),

                            const SizedBox(height: 8),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Caméra (${_images.length}/3)",

                                style: const TextStyle(
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,

                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// 🔄 LOADING
                    if (isUploadingImage)
                      const Padding(
                        padding:
                        EdgeInsets.only(top: 10),

                        child:
                        CircularProgressIndicator(),
                      ),

                    /// 🖼️ PREVIEW
                    if (_images.isNotEmpty)

                      Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 15,
                        ),

                        child: SizedBox(
                          height: 110,

                          child:
                          ListView.builder(

                            scrollDirection:
                            Axis.horizontal,

                            itemCount:
                            _images.length,

                            itemBuilder:
                                (context, index) {

                              return Padding(
                                padding:
                                const EdgeInsets.only(
                                  right: 10,
                                ),

                                child: Stack(
                                  children: [

                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(
                                        12,
                                      ),

                                      child: Image.file(
                                        File(
                                          _images[index]
                                              .path,
                                        ),

                                        width: 110,
                                        height: 200,

                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    Positioned(
                                      top: 5,
                                      right: 5,

                                      child:
                                      GestureDetector(

                                        onTap: () {

                                          setState(() {

                                            _images.removeAt(
                                              index,
                                            );

                                            if (uploadedImageUrls
                                                .length >
                                                index) {

                                              uploadedImageUrls
                                                  .removeAt(
                                                index,
                                              );
                                            }
                                          });
                                        },

                                        child: Container(
                                          decoration:
                                          const BoxDecoration(
                                            color: Colors.red,
                                            shape:
                                            BoxShape.circle,
                                          ),

                                          child: const Icon(
                                            Icons.close,
                                            color:
                                            Colors.white,

                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(

                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.orange,
                        ),

                        onPressed: () {

                          if (selectedCategory ==
                              null ||
                              _commentController.text
                                  .trim()
                                  .isEmpty) {

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Catégorie et commentaire requis",
                                ),
                              ),
                            );

                            return;
                          }

                          _submitSignalement();
                        },

                        child: const Text(
                          "Signaler le problème",

                          style: TextStyle(
                            color: Colors.white,
                          ),
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