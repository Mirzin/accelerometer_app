import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sensors_app/models/accelerometer_readings.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';

class SFGraph extends StatefulWidget {
  const SFGraph({Key? key}) : super(key: key);
  @override
  _SFGraphState createState() => _SFGraphState();
}

class _SFGraphState extends State<SFGraph> {
  late Map<dynamic, dynamic> arguments;
  Timer? timer;
  int period = 60;
  final db = FirebaseDatabase.instance.reference();
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<double> xaxis = [], yaxis = [], zaxis = [], time = [];
  late StreamSubscription streamSubscriptions;
  List<AccelerometerReadings> xspots = [];
  List<AccelerometerReadings> yspots = [];
  List<AccelerometerReadings> zspots = [];
  double x = 0, y = 0, z = 0, opacity = 0;
  num t = 0;
  late String name;

  void _plotGraph() async {
    // setState(() {
    //   _progress= t/period;
    // });
    if (t + period * 1000 < DateTime.now().millisecondsSinceEpoch - 200) {
      timer!.cancel();
      _storeData();
    }
    double xt = (DateTime.now().millisecondsSinceEpoch - t) / 1000;
    setState(() {
      xspots.add(AccelerometerReadings(x, xt));
      yspots.add(AccelerometerReadings(y, xt));
      zspots.add(AccelerometerReadings(z, xt));
      if (xspots.length > 100) {
        xspots.removeAt(0);
        yspots.removeAt(0);
        zspots.removeAt(0);
      }
    });
    xaxis.add(x);
    yaxis.add(y);
    zaxis.add(z);
    time.add(xt);
  }
  void _storeData() {
    final now = DateFormat.yMMMd().add_Hm().format(DateTime.now()) + name;
    setState(() {
      opacity = 1;
    });

    db.child("users/$uid/Readings/$now").set({
      "id": now,
      "x-axis": xaxis,
      "y-axis": yaxis,
      "z-axis": zaxis,
      "time": time,
    }).then((value) => Navigator.popAndPushNamed(context, "readings"));
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    period = arguments['period'];
    name = arguments['name'];
    //print("Building");
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 10,
            child: SfCartesianChart(
              primaryXAxis:
                  NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
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
        Opacity(
          opacity: opacity,
          child: Container(
            color: Colors.white.withOpacity(0.8),
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Saving Data"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    streamSubscriptions = (userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      x = event.x;
      y = event.y;
      z = event.z;
    }));
    t = DateTime.now().millisecondsSinceEpoch;
    timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      _plotGraph();
    });
  }

  @override
  void dispose() {
    streamSubscriptions.cancel();
    timer!.cancel();
    super.dispose();
  }
}
