// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sensors_app/widgets/dialogue.dart';

class HomePage extends StatefulWidget {
   const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accelerometer Readings"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed("profile");
          }, icon: Icon(Icons.account_circle))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
                fixedSize: const Size(200, 70),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              child: const Text("Record Accelerometer"),
              onPressed: () => dialogue(context),
            ),
            const SizedBox(height: 20,),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
                fixedSize: const Size(200, 70),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              child: const Text("Readings"),
              onPressed: () {
                Navigator.pushNamed(context, "readings");
              },
            ),
          ] 
        ),
      ),
    );
  }

  

  
}