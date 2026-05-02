import 'package:CITOYENS_2_0/homepage/custom_button.dart';
import 'package:flutter/material.dart';

class ConditionUtilisation extends StatelessWidget {
  const ConditionUtilisation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading:const CustomBackButton(),
        title:Text("CONDITION D'UTILISATION".toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 30,
            shadows: [Shadow(offset: Offset(3, 1), blurRadius: 2)] ),),
        centerTitle: true,
        actions: [
          const CustomMenuButton()
        ],
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
