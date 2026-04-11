import 'package:flutter/material.dart';

class APropos extends StatelessWidget {
  const APropos({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:Text("A Propos"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ici se trouve les infos concernant CITOYEN 2.0")
          ],
        )),
      ),
    );
  }
}
