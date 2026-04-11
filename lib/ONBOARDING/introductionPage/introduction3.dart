import 'package:flutter/material.dart';

class Introduction3 extends StatelessWidget {
  const Introduction3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Expanded(
          child: Image.asset('lib/images/5.png', fit: BoxFit.cover,),
        ),
      ],
    );
  }
}
