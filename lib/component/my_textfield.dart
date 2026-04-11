import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintext;
  final bool obscureText;
  MyTextfield(
      {super.key, required this.controller, required this.hintext, required this.obscureText,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            hintText: hintext,
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary
            )
        ),
      ),
    );
  }
}
