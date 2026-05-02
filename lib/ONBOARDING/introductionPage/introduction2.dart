import 'package:flutter/material.dart';

class Introduction2 extends StatelessWidget {
  const Introduction2({super.key});

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
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.02,
                ),
                child: Image.asset(
                  'lib/images/4.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),

            /// TEXTE


          ],
        ),
      ),
    );
  }
}