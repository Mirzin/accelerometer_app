import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sensors_app/services/custompageroute.dart';

class Readings extends StatefulWidget {
  const Readings({Key? key}) : super(key: key);

  @override
  State<Readings> createState() => _ReadingsState();
}

class _ReadingsState extends State<Readings> {
  final db = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();
  final List<Padding> readings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Readings"),
      ),
      body: StreamBuilder(
        stream: db.child("users/$uid/Readings").orderByKey().onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              (snapshot.data! as DatabaseEvent).snapshot.exists) {
            final data =
                (snapshot.data! as DatabaseEvent).snapshot.value as Map;
            List<int> keys = [];
            data.forEach((key, value) {
              keys.add(int.parse(key));
            });
            keys.sort();
            for (var i = 0; i < keys.length; i++) {
              final reading =
                  Map<String, dynamic>.from(data[keys[i].toString()]);
              final tile = Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.stacked_line_chart),
                  ),
                  title: Text(reading["id"]),
                  onTap: () {
                    Navigator.pushNamed(context, "viewgraph", arguments: {
                      "id": reading['id'],
                      'xspots': reading['x-axis'],
                      'yspots': reading['y-axis'],
                      'zspots': reading['z-axis'],
                      'time': reading['time'],
                    });
                  },
                  trailing: ElevatedButton(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                              const Size.fromRadius(20)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.all<CircleBorder>(
                            const CircleBorder(),
                          )),
                      child: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Delete Record?",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            fontSize: 20,
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red),
                                          ),
                                          onPressed: () {
                                            db
                                                .child(
                                                    "users/$uid/Readings/${keys[i]}")
                                                .remove();
                                                setState(() {
                                                  readings.removeAt(i);
                                                });                                            
                                            Navigator.pop(context);
                                          },
                                          child: const Icon(Icons.delete),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).then((value) {
                              //Navigator.popAndPushNamed(context, "readings");
                              Navigator.of(context).pushReplacement(CustomPageRoute(child: const Readings()));
                            });
                      }),
                ),
              );
              readings.insert(0, tile);
            }
            return ListView(
              children: readings,
            );
          } else if (snapshot.hasData &&
              !(snapshot.data! as DatabaseEvent).snapshot.exists) {
            return const Center(
                child: Text(
              "No Data Recorded",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
