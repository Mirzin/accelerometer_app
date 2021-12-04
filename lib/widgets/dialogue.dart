// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";

void setTimeDialogue(BuildContext context, String route) {
  final db = FirebaseDatabase.instance.reference();
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();
  String buttonText = "Select time";
  String submittext = "Start";
  int period = 60;
  bool _active = true;
  Timer? timer;
  TimeOfDay selectedtime = TimeOfDay.now();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Choose",
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                        primary: Colors.grey[600],
                        backgroundColor: Colors.white,
                        fixedSize: const Size(200, 55),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: Text(buttonText),
                      onPressed: () {
                        _showTimePicker(context).then((value) {
                          selectedtime = value as TimeOfDay;
                          setState(() {
                            buttonText = selectedtime.format(context);
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
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(submittext),
                      onPressed: !_active
                          ? null
                          : () async {
                              if (route == "M") {
                                db.child("users/$uid/runtime/").set({
                                  'hour': selectedtime.hour,
                                  'minute': selectedtime.minute,
                                  'period': period,
                                });
                              }
                              int timerseconds = 0;
                              FocusScope.of(context).requestFocus(FocusNode());
                              final int time = DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      selectedtime.hour,
                                      selectedtime.minute)
                                  .millisecondsSinceEpoch;
                              _active = false;
                              timer = Timer.periodic(
                                  Duration(milliseconds: 200), (timer) {
                                timerseconds = time -
                                    DateTime.now().millisecondsSinceEpoch;
                                if (timerseconds < 0) {
                                  timer.cancel();
                                }
                                setState(() {
                                  submittext = (timerseconds / 1000).toString();
                                });
                              });
                              Future.delayed(
                                  Duration(
                                      milliseconds: time -
                                          DateTime.now()
                                              .millisecondsSinceEpoch), () {
                                if (route == "M") {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.popAndPushNamed(context, "sfgraph",
                                      arguments: {
                                        "period": period,
                                        "name": " Main"
                                      });
                                }
                              });
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
  ).then((value) {
    timer?.cancel();
  });
}

Future<TimeOfDay?> _showTimePicker(BuildContext context) {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
}

void setNameDialogue(BuildContext context) {
  String name = '';
  bool _active = false;
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Choose",
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                        onChanged: (value) {
                          _active = true;
                          name = value;
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
                          hintText: "Name",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text("Connect"),
                    onPressed: !_active
                        ? null
                        : () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.popAndPushNamed(context, "connect",
                                arguments: {'name': name});
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
