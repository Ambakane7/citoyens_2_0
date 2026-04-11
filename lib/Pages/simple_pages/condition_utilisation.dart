import 'package:flutter/material.dart';

class ConditionUtilisation extends StatelessWidget {
  const ConditionUtilisation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:Text("Condition d'Utilisation"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ici se trouve les infos concernant les conditions d'utilisation")
          ],
        )),
      ),
    );
  }
}
