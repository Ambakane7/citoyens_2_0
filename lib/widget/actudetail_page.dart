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
        title: const Text(
          "Actualité",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (data['title'] ?? "").toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (data['author'] ?? "").toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildContent(content),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(dynamic content) {
    /// Cas Markdown
    if (content is String) {
      return MarkdownBody(data: content);
    }

    /// Cas Quill JSON (sans flutter_quill)
    if (content is List) {
      return SelectableText(
        _quillJsonToPlainText(content),
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
        ),
      );
    }

    return const Text("Aucun contenu");
  }

  String _quillJsonToPlainText(List<dynamic> json) {
    final buffer = StringBuffer();

    for (final item in json) {
      if (item is Map &&
          item.containsKey('insert') &&
          item['insert'] is String) {
        buffer.write(item['insert']);
      }
    }

    return buffer.toString();
  }
}