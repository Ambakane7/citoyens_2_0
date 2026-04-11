import 'package:flutter/material.dart';

import '../models/model_categorie.dart';


Future<Map<String, dynamic>?> showTypeSelectorBottomSheet({
  required BuildContext context,
  required List<Category> categories,
}) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      int step = 0;
      Category? selectedCategory;
      String? selectedSubCategory;

      return StatefulBuilder(
        builder: (context, setStateModal) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [

                /// HEADER
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (step == 1)
                        TextButton(
                          onPressed: () {
                            setStateModal(() {
                              step = 0;
                              selectedSubCategory = null;
                            });
                          },
                          child: const Text("Retour"),
                        ),
                      const Spacer(),
                      const Text(
                        "Type",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                /// BOUTON VALIDER
                if (step == 1 && selectedSubCategory != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text("Valider"),
                      onPressed: () {
                        Navigator.pop(context, {
                          "category": selectedCategory,
                          "subCategory": selectedSubCategory,
                        });
                      },
                    ),
                  ),

                const SizedBox(height: 10),

                /// LISTE
                Expanded(
                  child: ListView.separated(
                    itemCount: step == 0
                        ? categories.length
                        : selectedCategory!.subCategories.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (step == 0) {
                        final category = categories[index];
                        return _sheetItem(
                          label: category.name,
                          selected: false,
                          onTap: () {
                            setStateModal(() {
                              selectedCategory = category;
                              step = 1;
                            });
                          },
                        );
                      } else {
                        final sub = selectedCategory!.subCategories[index];
                        return _sheetItem(
                          label: sub,
                          selected: sub == selectedSubCategory,
                          onTap: () {
                            setStateModal(() {
                              selectedSubCategory = sub;
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _sheetItem({
  required String label,
  required bool selected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: selected ? Colors.orange : Colors.grey,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          const Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    ),
  );
}
