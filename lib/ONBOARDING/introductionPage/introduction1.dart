import 'package:flutter/material.dart';

class Introduction1 extends StatelessWidget {
  const Introduction1({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            /// IMAGE
            Expanded(
              flex: isTablet ? 2 : 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.07,
                  vertical: size.height * 0.02,
                ),
                child: Image.asset(
                  'lib/images/3.png',
                  fit: BoxFit.contain, // évite le crop
                  width: double.infinity,
                ),
              ),
            ),

            /// TEXTE (placeholder pour la suite)


          ],
        ),
      ),
    );
  }
}