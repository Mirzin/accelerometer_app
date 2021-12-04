// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Readings extends StatelessWidget {
  Readings({ Key? key }) : super(key: key);

  final db = FirebaseDatabase.instance.reference();
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();
  final List<ListTile> readings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Readings"),
      ),
      body: StreamBuilder(
        stream: db.child("users/$uid/Readings").onValue,
        builder: (context, snapshot) {
          if(snapshot.hasData && (snapshot.data! as Event).snapshot.exists) {
            //print((snapshot.data! as Event).snapshot.exists);
            final data = Map<String, dynamic>.from((snapshot.data as Event).snapshot.value);
            data.forEach((key, value) {
              final reading = Map<String, dynamic>.from(value);
              final tile = ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.stacked_line_chart),
                ),
                title: Text(reading["id"]),
                onTap: () {
                  Navigator.pushNamed(context, "viewgraph",arguments: {
                    "id" : reading['id'],
                    'xspots' : reading['x-axis'],
                    'yspots' : reading['y-axis'],
                    'zspots' : reading['z-axis'],
                    'time' : reading['time'],
                  });
                },
              );
              readings.insert(0, tile);
            });
            return ListView(
              children: readings,
            );
          }
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}