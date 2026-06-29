import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../Pages/allsignal.dart';
import '../Pages/report/signalementpage.dart';
import '../Pages/simple_pages/menu_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  LatLng? _selectedPosition;
  bool _isLoadingLocation = true;

  List<Map<String, dynamic>> _signals = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _detectUserLocation();
    await _loadSignals();
  }

  /// 📍 POSITION
  Future<void> _detectUserLocation() async {

    try {

      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showError("Active la localisation GPS");

        setState(() {
          _selectedPosition = LatLng(12.6392, -8.0029);
          _isLoadingLocation = false;
        });

        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {

        setState(() {
          _selectedPosition = LatLng(12.6392, -8.0029);
          _isLoadingLocation = false;
        });

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        _selectedPosition =
            LatLng(position.latitude, position.longitude);

        _isLoadingLocation = false;
      });

    } catch (e) {

      setState(() {
        _selectedPosition = LatLng(12.6392, -8.0029);
        _isLoadingLocation = false;
      });

      _showError("Erreur localisation");
    }
  }

  /// 🔥 FIRESTORE
  Future<void> _loadSignals() async {

    final snap = await FirebaseFirestore.instance
        .collection('signalements')
        .get();

    setState(() {

      _signals = snap.docs.map((doc) {

        final data = doc.data();

        return {
          "id": doc.id,
          "lat": (data["latitude"] ?? 0).toDouble(),
          "lng": (data["longitude"] ?? 0).toDouble(),
        };

      }).toList();

    });
  }

  void _showError(String message) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoadingLocation || _selectedPosition == null) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    /// 🔥 FILTRE PROXIMITÉ
    final nearbySignals = _signals.where((signal) {

      final distance = Geolocator.distanceBetween(
        _selectedPosition!.latitude,
        _selectedPosition!.longitude,
        signal["lat"],
        signal["lng"],
      );

      return distance < 5000;

    }).toList();

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,

        centerTitle: true,

        title: Image.asset(
          "lib/images/no_bg.png",
          fit: BoxFit.contain,
        ),

        actions: [

          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 32,
            ),

            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MenuPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: Stack(

        children: [


          Positioned.fill(
            child: Image.asset(
              "lib/images/3.png",
              fit: BoxFit.contain,
            ),
          ),
          /// 🔽 CONTAINER
          Positioned(
            left: 0,
            right: 0,
            bottom: 45,

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Stack(
                clipBehavior: Clip.none,

                children: [

                  Container(
                    height: 110,
                    width: double.infinity,

                    padding: const EdgeInsets.only(top: 40),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                        ),
                      ],
                    ),

                    child: GestureDetector(

                      onTap: nearbySignals.isEmpty
                          ? null
                          : () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllSignalement(
                              selectedId:
                              nearbySignals.first["id"],
                            ),
                          ),
                        );
                      },

                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          Text(
                            nearbySignals.isEmpty
                                ? "0 problème détecté dans cette zone"
                                : "${nearbySignals.length} problème${nearbySignals.length > 1 ? "s" : ""} détecté${nearbySignals.length > 1 ? "s" : ""}",

                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),

                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 6),

                          Text(
                            nearbySignals.isEmpty
                                ? "Aucun signalement trouvé actuellement"
                                : "Appuyez pour voir les détails",

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 🟧 BOUTON
                  Positioned(
                    top: -30,
                    left: 16,
                    right: 16,

                    child: Material(
                      elevation: 6,

                      borderRadius:
                      BorderRadius.circular(14),

                      child: GestureDetector(

                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const Signalement(),
                            ),
                          );
                        },

                        child: Container(
                          height: 56,

                          decoration: BoxDecoration(
                            color: Colors.amber,

                            borderRadius:
                            BorderRadius.circular(14),
                          ),

                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [

                              Icon(
                                Icons.report_problem,
                                color: Colors.white,
                              ),

                              SizedBox(width: 8),

                              Text(
                                "Signaler un problème",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}