import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sensors_app/models/period_time.dart';
import 'package:sensors_app/screens/home/profile.dart';
import 'package:sensors_app/screens/home/readings.dart';
import 'package:sensors_app/services/custompageroute.dart';
import 'package:sensors_app/widgets/sfgraph.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String now;
  String name = '';
  final db = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();
  late PeriodTime data;
  num t = DateTime.now().millisecondsSinceEpoch;
  int period = 60;
  String buttonText = "Select time";
  TimeOfDay selectedtime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accelerometer Readings"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(CustomPageRoute(child: const ProfilePage()));
              },
              icon: const Icon(Icons.account_circle))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
                  fixedSize: const Size(200, 70),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                child: const Text("Record Accelerometer"),
                onPressed: () => Navigator.of(context).push(CustomPageRoute(
                    child: const SFGraph(name: "", slave: false))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
                  fixedSize: const Size(200, 70),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                child: const Text("Readings"),
                onPressed: () {
                  Navigator.of(context)
                      .push(CustomPageRoute(child: const Readings()));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
                  fixedSize: const Size(200, 70),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                child: const Text("Record on Multiple Devices"),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: "Choose",
                    barrierColor: Colors.black.withOpacity(0.5),
                    pageBuilder: (BuildContext buildContext,
                        Animation animation, Animation secondaryAnimation) {
                      return StatefulBuilder(builder: (context, setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Center(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.grey),
                                        primary: Colors.grey[600],
                                        backgroundColor: Colors.white,
                                        fixedSize: const Size(200, 55),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      child: Text(buttonText),
                                      onPressed: () {
                                        _showTimePicker(context).then((value) {
                                          selectedtime = value as TimeOfDay;
                                          setState(() {
                                            buttonText =
                                                selectedtime.format(context);
                                          });
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 200,
                                        child: TextField(
                                          onChanged: (value) {
                                            period = int.parse(value);
                                          },
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          cursorHeight: 25,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "Seconds to record",
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      child: const Text("Submit"),
                                      onPressed: () {
                                        db.child("users/$uid/runtime/").set({
                                          'hour': selectedtime.hour,
                                          'minute': selectedtime.minute,
                                          'period': period,
                                        }).then((value) => Navigator.pop(context));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
                  fixedSize: const Size(200, 70),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                child: const Text("Connect"),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: "Name",
                    barrierColor: Colors.black.withOpacity(0.5),
                    pageBuilder: (BuildContext buildContext,
                        Animation animation, Animation secondaryAnimation) {
                      return StatefulBuilder(builder: (context, setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Center(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 200,
                                        child: TextField(
                                          onChanged: (value) {
                                            name = value;
                                          },
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          cursorHeight: 25,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            hintText: "Name",
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      child: const Text("Connect"),
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.of(context)
                                            .pushReplacement(CustomPageRoute(
                                                child: SFGraph(
                                          name: name,
                                          slave: true,
                                        )));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> _showTimePicker(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }
}
