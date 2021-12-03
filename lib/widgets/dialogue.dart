// ignore_for_file: prefer_const_constructors

import 'dart:async';
import "package:flutter/material.dart";

void dialogue(BuildContext context) {
    
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
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
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
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        onPressed: !_active ? null : () async {
                          int hours = 0, minutes = 0, seconds = 0, timerseconds = 0;
                          FocusScope.of(context).requestFocus(FocusNode());
                          if(selectedtime.hour < TimeOfDay.now().hour || (selectedtime.hour == TimeOfDay.now().hour && selectedtime.minute < TimeOfDay.now().minute)) {}
                          else if(selectedtime.hour > TimeOfDay.now().hour && selectedtime.minute < TimeOfDay.now().minute) {
                            minutes = (60 - DateTime.now().minute) + selectedtime.minute - 1;
                            seconds = 60 - DateTime.now().second;
                            timerseconds = (minutes * 60) + seconds;
                          }
                          else {
                            hours = selectedtime.hour - DateTime.now().hour;
                            minutes = selectedtime.minute - DateTime.now().minute - 1;
                            seconds = 60 - DateTime.now().second;
                            timerseconds = (minutes * 60) + seconds;
                          }
                          _active = false;
                          timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
                              timerseconds -= 1;
                              if(timerseconds == 0) {
                                timer.cancel();
                              }
                              setState(() {
                                submittext = "$timerseconds";
                              });
                          });
                          Future.delayed(Duration(hours: hours, minutes: minutes, seconds: seconds), () {
                            Navigator.popAndPushNamed(context, "sfgraph", arguments: {
                              "period" : period,
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
         }
        );
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