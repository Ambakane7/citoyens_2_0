import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class ActuDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ActuDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final date = data['createdAt'] != null
        ? DateFormat("dd MMM yyyy").format(data['createdAt'].toDate())
        : "";

    final content = data['content'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Actualité", style: TextStyle(color: Colors.white
        ),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 📰 TITRE
            Text(
              (data['title'] ?? "").toString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// 👤 + DATE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (data['author'] ?? "").toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(date, style: const TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔥 CONTENU INTELLIGENT
            _buildContent(content),
          ],
        ),
      ),
    );
  }

  /// 🔥 GESTION QUILL + MARKDOWN
  Widget _buildContent(dynamic content) {
    /// 👉 CAS QUILL (JSON)
    if (content is List) {
      try {
        final controller = quill.QuillController(
          document: quill.Document.fromJson(content),
          selection: const TextSelection.collapsed(offset: 0),
        );

        return SizedBox(
          height: 400,
          child: quill.QuillEditor.basic(controller: controller),
        );
      } catch (e) {
        return const Text("Erreur d'affichage");
      }
    }

    /// 👉 CAS MARKDOWN
    if (content is String) {
      return MarkdownBody(data: content);
    }

    return const Text("Aucun contenu");
  }
}
