import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:womentech/Pages/report/signalementpage.dart';
import 'package:womentech/Pages/allsignal.dart';
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
      final position = await Geolocator.getCurrentPosition();

      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });
    } catch (e) {
      _showError("Erreur localisation");
    }
  }

  /// 🔥 FIRESTORE
  Future<void> _loadSignals() async {
    final snap =
    await FirebaseFirestore.instance.collection('signalements').get();

    setState(() {
      _signals = snap.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "lat": (data["lat"] ?? 0).toDouble(),
          "lng": (data["lng"] ?? 0).toDouble(),
        };
      }).toList();
    });
  }

  void _showError(String message) {
    setState(() => _isLoadingLocation = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingLocation || _selectedPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
      return distance < 2000;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Image.asset("lib/images/no_bg.png", fit: BoxFit.contain,),
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
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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

          /// 🔽 CONTAINER
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
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
                        BoxShadow(color: Colors.black12, blurRadius: 6),
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
                              selectedId: nearbySignals.first["id"],
                            ),
                          ),
                        );
                      },

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            nearbySignals.isEmpty
                                ? "Aucun problème rapporté dans cette zone."
                                : "${nearbySignals.length} problème(s) détecté(s)",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 6),

                          Text(
                            nearbySignals.isEmpty
                                ? "Déplacez la carte pour trouver des signalements"
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
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Signalement(),
                            ),
                          );
                        },
                        child: const Text(
                          "! Signaler un problème",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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