import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sensors_app/models/accelerometer_readings.dart';
import 'package:sensors_app/models/period_time.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'package:flutter_sensors/flutter_sensors.dart';

class SFGraph extends StatefulWidget {
  const SFGraph({Key? key, required this.name, required this.slave})
      : super(key: key);
  final String name;
  final bool slave;
  @override
  _SFGraphState createState() => _SFGraphState();
}

class _SFGraphState extends State<SFGraph> {
  late String now;
  final db = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();

  late StreamSubscription _accelSubscription;
  late Stream<SensorEvent> stream;
  late PeriodTime data;
  List<double> xaxis = [], yaxis = [], zaxis = [], time = [];
  List<AccelerometerReadings> xspots = [];
  List<AccelerometerReadings> yspots = [];
  List<AccelerometerReadings> zspots = [];
  double xt = 0, x = 0, y = 0, z = 0, c = 0;
  num t = DateTime.now().millisecondsSinceEpoch;
  bool _storing = false;
  int period = 60;
  String buttonText = "Select time";
  String starttext = "Start";
  TimeOfDay selectedtime = TimeOfDay.now();

  void _plotGraph() {
    if (t + period * 1000 < DateTime.now().millisecondsSinceEpoch - 200) {
      _accelSubscription.cancel();
      //ui!.cancel();
      _storeData();
    }
    xt = (DateTime.now().millisecondsSinceEpoch - t) / 1000;
    if (c % 5 == 0) {
      setState(() {
        xspots.add(AccelerometerReadings(x, xt));
        yspots.add(AccelerometerReadings(y, xt));
        zspots.add(AccelerometerReadings(z, xt));
        if (xspots.length > 20) {
          xspots.removeAt(0);
          yspots.removeAt(0);
          zspots.removeAt(0);
        }
      });
    }
    xaxis.add(x);
    yaxis.add(y);
    zaxis.add(z);
    time.add(xt);
    c++;
  }

  void _storeData() {
    setState(() {
      _storing = true;
    });
    String key = DateTime.now().millisecondsSinceEpoch.toString();
    db.child("users/$uid/Readings/$key").set({
      "id": now,
      "x-axis": xaxis,
      "y-axis": yaxis,
      "z-axis": zaxis,
      "time": time,
    }).then((value) => Navigator.popAndPushNamed(context, "readings"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors'),
        centerTitle: true,
      ),
      body: _storing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Saving Data"),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 10,
                    child: SfCartesianChart(
                      primaryXAxis: NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.shift),
                      series: <ChartSeries>[
                        LineSeries<AccelerometerReadings, double>(
                          color: Colors.blue,
                          dataSource: xspots,
                          xValueMapper: (AccelerometerReadings xspots, _) =>
                              xspots.time,
                          yValueMapper: (AccelerometerReadings xspots, _) =>
                              xspots.reading,
                        ),
                        LineSeries<AccelerometerReadings, double>(
                          color: Colors.yellow,
                          dataSource: yspots,
                          xValueMapper: (AccelerometerReadings yspots, _) =>
                              yspots.time,
                          yValueMapper: (AccelerometerReadings yspots, _) =>
                              yspots.reading,
                        ),
                        LineSeries<AccelerometerReadings, double>(
                          color: Colors.red,
                          dataSource: zspots,
                          xValueMapper: (AccelerometerReadings zspots, _) =>
                              zspots.time,
                          yValueMapper: (AccelerometerReadings zspots, _) =>
                              zspots.reading,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: widget.slave
                        ? () {}
                        : () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: "Choose",
                              barrierColor: Colors.black.withOpacity(0.5),
                              pageBuilder: (BuildContext buildContext,
                                  Animation animation,
                                  Animation secondaryAnimation) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Center(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  side: const BorderSide(
                                                      color: Colors.grey),
                                                  primary: Colors.grey[600],
                                                  backgroundColor: Colors.white,
                                                  fixedSize:
                                                      const Size(200, 55),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                ),
                                                child: Text(buttonText),
                                                onPressed: () {
                                                  _showTimePicker(context)
                                                      .then((value) {
                                                    selectedtime =
                                                        value as TimeOfDay;
                                                    setState(() {
                                                      buttonText = selectedtime
                                                          .format(context);
                                                    });
                                                  });
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      period = int.parse(value);
                                                    },
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                    cursorHeight: 25,
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Seconds to record",
                                                      hintStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey[600],
                                                        fontSize: 14,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
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
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  final int time = DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day,
                                                          selectedtime.hour,
                                                          selectedtime.minute)
                                                      .millisecondsSinceEpoch;
                                                  data =
                                                      PeriodTime(period, time);
                                                  Navigator.pop(context);
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
                            ).then((_) {
                              startTimer(data.timerseconds);
                            });
                            //start();
                          },
                    child: Text(
                      starttext,
                      style: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void startTimer(int t) {
    int time = t;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      time = t - DateTime.now().millisecondsSinceEpoch;
      if (time <= 0) {
        timer.cancel();
        start();
      }
      if (mounted) {
        setState(() {
          starttext = time <= 0 ? "Recording" : (time / 1000).toStringAsFixed(2);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    now =
        DateFormat.yMMMd().add_jm().format(DateTime.now()) + " " + widget.name;
  }

  void start() {
    xaxis = [];
    yaxis = [];
    zaxis = [];
    time = [];
    xspots = [];
    yspots = [];
    zspots = [];
    now =
        DateFormat.yMMMd().add_jm().format(DateTime.now()) + " " + widget.name;
    t = DateTime.now().millisecondsSinceEpoch;
    _accelSubscription.onData((event) {
      x = event.data[0];
      y = event.data[1];
      z = event.data[2] + 0.08;
      _plotGraph();
    });
  }

  void init() async {
    if (widget.slave) {
      final setdata = await db.child("users/$uid/runtime").get();
      final data = setdata.value as Map;
      period = data["period"];
      final int time = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, data["hour"], data["minute"])
          .millisecondsSinceEpoch;
    startTimer(time);
    }
    stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.LINEAR_ACCELERATION,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );
    _accelSubscription = stream.listen((event) {
      // x = event.data[0];
      // y = event.data[1];
      // z = event.data[2];
      // _plotGraph();
    });
  }

  Future<TimeOfDay?> _showTimePicker(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  @override
  void dispose() {
    _accelSubscription.cancel();
    super.dispose();
  }
}
