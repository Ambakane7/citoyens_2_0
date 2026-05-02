import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:Text("Contact".toUpperCase(), style: TextStyle(color: Colors.white,fontSize: 30,
            shadows: [Shadow(offset: Offset(3, 1), blurRadius: 2)] ),),
        leading: const CustomBackButton(),
        centerTitle: true,
        actions: [const CustomMenuButton()],
      ),
      body: SingleChildScrollView(
        child: SafeArea(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ici se trouve les infos concernant le contact")
          ],
        )),
      ),
    );
  }
}
