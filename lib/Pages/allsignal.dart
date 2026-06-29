import 'package:CITOYENS_2_0/Pages/report/signalement_detail_page.dart';
import 'package:CITOYENS_2_0/Pages/report/signalementpage.dart';
import 'package:CITOYENS_2_0/Pages/simple_pages/menu_page.dart';
import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class AllSignalement extends StatefulWidget {
  final String? selectedId;

  const AllSignalement({super.key, this.selectedId});

  @override
  State<AllSignalement> createState() => _AllSignalementState();
}

class _AllSignalementState extends State<AllSignalement> {

  final ScrollController _scrollController = ScrollController();

  bool showFilterPanel = false;
  bool showOnlyMyZone = false;
  bool filterByStatus = false;
  bool showArchives = false;
  String? selectedSeverityFilter;
  DateTime? selectedDateFilter;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title:  Text(
          "Tous les signalements".toUpperCase(),
          style: TextStyle(color: Colors.white,fontSize: 15,
              shadows: [Shadow(offset: Offset(3, 1), blurRadius: 2)] ),
        ),
        leading: const CustomBackButton(),
        actions: [
          const CustomMenuButton()
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

  /// ===================== TOP ACTIONS =====================
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
                      style: TextStyle(color: Colors.white)),
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
                      style: TextStyle(color: Colors.white)),
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
          Column(
            children: [
              CheckboxListTile(
                value: filterByStatus,
                onChanged: (v) =>
                    setState(() => filterByStatus = v!),
                title: const Text("Afficher seulement en cours"),
              ),

              CheckboxListTile(
                value: showArchives,
                onChanged: (v) =>
                    setState(() => showArchives = v!),
                title: const Text("Afficher traités"),
              ),
              /// 🔥 FILTRE SEVERITE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  value: selectedSeverityFilter,
                  hint: const Text("Filtrer par gravité"),
                  items: ["Critique", "Grave", "Moyen", "Faible"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() => selectedSeverityFilter = val);
                  },
                ),
              ),

              /// 🔥 FILTRE DATE
              ListTile(
                title: Text(
                  selectedDateFilter == null
                      ? "Filtrer par date"
                      : "Date : ${DateFormat('dd/MM/yyyy').format(selectedDateFilter!)}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                  );

                  if (picked != null) {
                    setState(() => selectedDateFilter = picked);
                  }
                },
              ),
            ],
          ),
      ],
    );
  }

  /// ===================== LISTE =====================
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
          final data = doc.data() as Map<String, dynamic>;
          final status = data['status'] ?? "en_cours";

          if (filterByStatus && status != 'en_cours') return false;
          if (showArchives && status != 'traite') return false;

          /// 🔥 FILTRE SEVERITE
          if (selectedSeverityFilter != null &&
              data['severity'] != selectedSeverityFilter) {
            return false;
          }

          /// 🔥 FILTRE DATE
          if (selectedDateFilter != null) {
            final Timestamp? ts = data['createdAt'];
            if (ts == null) return false;

            final date = ts.toDate();

            if (date.year != selectedDateFilter!.year ||
                date.month != selectedDateFilter!.month ||
                date.day != selectedDateFilter!.day) {
              return false;
            }
          }

          return true;
        }).toList();

        if (docs.isEmpty) {
          return const Center(child: Text("Aucun signalement"));
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (_, i) => _dismissibleCard(docs[i]),
        );
      },
    );
  }

  /// ===================== CARD =====================
  Widget _dismissibleCard(QueryDocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>;

    final Timestamp? ts = data['createdAt'];

    final date = ts != null
        ? DateFormat('dd/MM/yyyy HH:mm')
        .format(ts.toDate())
        : 'Date inconnue';

    final String status =
        data['status'] ?? 'en_cours';

    final String severity =
        data['severity'] ?? 'Faible';

    /// 📸 IMAGES
    final List images =
        data['images'] ?? [];

    return GestureDetector(

      onTap: () {

        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) =>
                SignalementDetailPage(
                  data: data,
                ),
          ),
        );
      },

      child: Card(

        margin:
        const EdgeInsets.only(bottom: 12),

        elevation: 3,

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),

        child: Padding(

          padding: const EdgeInsets.all(12),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              /// 📸 IMAGES
              if (images.isNotEmpty)

                SizedBox(
                  height: 90,

                  child: ListView.builder(

                    scrollDirection:
                    Axis.horizontal,

                    itemCount:
                    images.length > 3
                        ? 3
                        : images.length,

                    itemBuilder:
                        (context, index) {

                      return Padding(

                        padding:
                        const EdgeInsets.only(
                          right: 8,
                          bottom: 10,
                        ),

                        child: ClipRRect(

                          borderRadius:
                          BorderRadius.circular(
                            10,
                          ),

                          child: Stack(
                            children: [

                              Image.network(
                                images[index],

                                width: 85,
                                height: 85,

                                fit: BoxFit.cover,

                                loadingBuilder:
                                    (
                                    context,
                                    child,
                                    progress,
                                    ) {

                                  if (progress ==
                                      null) {

                                    return child;
                                  }

                                  return Container(
                                    width: 85,
                                    height: 85,

                                    color: Colors
                                        .grey
                                        .shade200,

                                    alignment:
                                    Alignment.center,

                                    child:
                                    const SizedBox(
                                      width: 20,
                                      height: 20,

                                      child:
                                      CircularProgressIndicator(
                                        strokeWidth:
                                        2,
                                      ),
                                    ),
                                  );
                                },

                                errorBuilder:
                                    (
                                    context,
                                    error,
                                    stackTrace,
                                    ) {

                                  return Container(
                                    width: 85,
                                    height: 85,

                                    color: Colors
                                        .grey
                                        .shade300,

                                    alignment:
                                    Alignment.center,

                                    child:
                                    const Icon(
                                      Icons
                                          .broken_image,

                                      color:
                                      Colors.grey,
                                    ),
                                  );
                                },
                              ),

                              /// ➕ PHOTOS SUPP
                              if (index == 2 &&
                                  images.length > 3)

                                Container(
                                  width: 85,
                                  height: 85,

                                  color:
                                  Colors.black54,

                                  alignment:
                                  Alignment.center,

                                  child: Text(
                                    "+${images.length - 3}",

                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white,

                                      fontWeight:
                                      FontWeight.bold,

                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              /// 🔝 HEADER
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Expanded(
                    child: Text(
                      "${data['category'] ?? ""} - ${data['subCategory'] ?? ""}",

                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,

                        fontSize: 15,
                      ),
                    ),
                  ),

                  _severityBadge(
                    data['severity'] ??
                        "Faible",
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// 📍 POSITION
              Text(
                "📍 ${data['latitude'] ?? ""}, ${data['longitude'] ?? ""}",

                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 4),

              /// 👤 AUTEUR
              Text(
                data['authorType'] ==
                    "anonymous"

                    ? "👤 Anonyme"

                    : "👤 ${data['firstName'] ?? ""} ${data['lastName'] ?? ""}",

                style: const TextStyle(
                  fontWeight:
                  FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              /// 💬 COMMENTAIRE
              Text(
                data['comment'] ?? "",

                maxLines: 2,

                overflow:
                TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 10),

              /// 🕒 DATE
              Text(
                "🕒 $date",

                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 10),

              /// 📌 STATUS
              _statusBadge(
                data['status'] ??
                    "en_cours",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===================== BADGE STATUS =====================
  Widget _statusBadge(String status) {
    Color color;
    IconData icon;
    String label;

    switch (status) {

      case 'verifie':
        color = Colors.green;
        icon = Icons.check_circle;
        label = "Vérifié";
        break;

      case 'non_verifie':
        color = Colors.grey;
        icon = Icons.warning_amber_rounded;
        label = "Non vérifié";
        break;

      case 'en_cours':
      default:
        color = Colors.orange;
        icon = Icons.hourglass_bottom;
        label = "En cours";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// ===================== BADGE SEVERITY =====================
  Widget _severityBadge(String severity) {
    Color color = Colors.grey;

    switch (severity) {
      case "Critique":
        color = Colors.red;
        break;
      case "Grave":
        color = Colors.orange;
        break;
      case "Moyen":
        color = Colors.amber;
        break;
      case "Faible":
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        severity,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}