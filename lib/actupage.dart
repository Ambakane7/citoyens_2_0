import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:CITOYENS_2_0/widget/actudetail_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


import 'Pages/simple_pages/menu_page.dart';


class ActuPage extends StatelessWidget {
  const ActuPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title:  Text(
          "ACTUALITE".toUpperCase(),
          style: TextStyle(color: Colors.white,fontSize: 30,
              shadows: [Shadow(offset: Offset(3, 1), blurRadius: 2)] ),
        ),
        leading: const CustomBackButton(),
        actions: [
          const CustomMenuButton()
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('publications')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          /// 🔄 LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ❌ ERROR
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement"));
          }

          /// 📭 EMPTY
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucune publication"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,

            itemBuilder: (context, index) {

              final d = docs[index].data() as Map<String, dynamic>;

              /// 📅 DATE SAFE
              final date = d['createdAt'] != null
                  ? DateFormat("dd MMM yyyy")
                  .format(d['createdAt'].toDate())
                  : "";

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActuDetailPage(data: d),
                    ),
                  );
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 📰 TITRE
                        Text(
                          (d['title'] ?? "").toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// 🔥 PREVIEW TEXTE (depuis Quill)
                        Text(
                          _extractPlainText(d['content']),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// FOOTER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            /// DATE
                            Text(
                              date,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),

                            /// AUTEUR
                            Text(
                              (d['author'] ?? "").toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 🔥 EXTRACTION TEXTE DEPUIS QUILL JSON
  String _extractPlainText(dynamic content) {
    try {
      if (content is List) {
        return content
            .map((e) => e['insert'] ?? "")
            .join()
            .toString();
      }
      return "";
    } catch (e) {
      return "";
    }
  }
}