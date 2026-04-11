import 'package:flutter/material.dart';

class Introduction2 extends StatelessWidget {
  const Introduction2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [

          // IMAGE (prend l'espace dispo)
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'lib/images/4.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // TEXTE

        ],
      ),
    );
  }
}