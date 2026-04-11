import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:womentech/Pages/report/signalementpage.dart';
import 'package:womentech/Pages/simple_pages/menu_page.dart';

class AllSignalement extends StatefulWidget {
  final String? selectedId; // ✅ AJOUT IMPORTANT

  const AllSignalement({super.key, this.selectedId});

  @override
  State<AllSignalement> createState() => _AllSignalementState();
}

class _AllSignalementState extends State<AllSignalement> {

  // 🔥 SCROLL CONTROLLER
  final ScrollController _scrollController = ScrollController();

  // ===== Filtres =====
  bool showFilterPanel = false;
  bool showOnlyMyZone = false;
  bool filterByStatus = false;
  bool showArchives = false;

  @override
  Widget build(BuildContext context) {

    // 🔥 DEBUG
    print("ID reçu: ${widget.selectedId}");

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Tous les signalements",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MenuPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _topActions(),
          Expanded(child: _signalementList()),
        ],
      ),
    );
  }

  // ===================== TOP ACTIONS =====================

  Widget _topActions() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.tune),
                  label: const Text("Filtrer",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      showFilterPanel = !showFilterPanel;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Créer",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
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
                ),
              ),
            ],
          ),
        ),

        if (showFilterPanel)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                CheckboxListTile(
                  value: showOnlyMyZone,
                  onChanged: (v) =>
                      setState(() => showOnlyMyZone = v!),
                  title: const Text("Afficher uniquement ma zone"),
                ),
                CheckboxListTile(
                  value: filterByStatus,
                  onChanged: (v) =>
                      setState(() => filterByStatus = v!),
                  title: const Text("Filtrer par statut"),
                ),
                CheckboxListTile(
                  value: showArchives,
                  onChanged: (v) =>
                      setState(() => showArchives = v!),
                  title: const Text("Archives"),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ===================== LISTE =====================

  Widget _signalementList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('signalements')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs.where((doc) {
          if (filterByStatus && doc['status'] != 'en_cours') return false;
          if (showArchives && doc['status'] != 'resolu') return false;
          return true;
        }).toList();

        if (docs.isEmpty) {
          return const Center(child: Text("Aucun signalement"));
        }

        // 🔥 SCROLL AUTOMATIQUE
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.selectedId != null) {
            final index =
            docs.indexWhere((d) => d.id == widget.selectedId);

            if (index != -1) {
              _scrollController.animateTo(
                index * 140,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          }
        });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (_, i) => _dismissibleCard(docs[i]),
        );
      },
    );
  }

  // ===================== CARD =====================

  Widget _dismissibleCard(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final bool isSelected = doc.id == widget.selectedId; // ✅ clé

    final Timestamp? ts = data['createdAt'];
    final date = ts != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(ts.toDate())
        : 'Date inconnue';

    final String status = data['status'] ?? 'en_cours';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      // 🔥 SURBRILLANCE
      color: isSelected ? Colors.amber.shade100 : Colors.white,

      child: ListTile(
        title: Text("${data['category']} - ${data['subCategory']}"),
        subtitle: Text("Soumis le $date"),
        trailing: _statusBadge(status),
      ),
    );
  }

  // ===================== BADGE =====================

  Widget _statusBadge(String status) {
    final bool enCours = status == 'en_cours';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: enCours ? Colors.orange : Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        enCours ? "En cours" : "Traité",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}