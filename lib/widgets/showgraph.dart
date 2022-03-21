import 'package:flutter/material.dart';
import 'package:sensors_app/models/accelerometer_readings.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ShowGraph extends StatefulWidget {
  const ShowGraph({ Key? key, required this.xspots, required this.yspots,required this.zspots, required this.time }) : super(key: key);
  final List xspots, yspots, zspots, time;
  @override
  _ShowGraphState createState() => _ShowGraphState();
}

class _ShowGraphState extends State<ShowGraph> {
  final List<AccelerometerReadings> xaxis = [];
  final List<AccelerometerReadings> yaxis = [];
  final List<AccelerometerReadings> zaxis = [];
  int count = 0;

  void setData() {
    for(double point in widget.xspots) {
      xaxis.add(AccelerometerReadings(point, widget.time[count]));
      count++;
    }
    count = 0;
    for(double point in widget.yspots) {
      yaxis.add(AccelerometerReadings(point, widget.time[count]));
      count++;
    }
    count = 0;
    for(double point in widget.zspots) {
      zaxis.add(AccelerometerReadings(point, widget.time[count]));
      count++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SfCartesianChart(
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                ),
              primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
              series: <ChartSeries>[
                LineSeries<AccelerometerReadings, double>(
                  color: Colors.blue,
                  dataSource: xaxis, 
                  xValueMapper: (AccelerometerReadings xspots, _) => xspots.time, 
                  yValueMapper: (AccelerometerReadings xspots, _) => xspots.reading,
                 ),
                 LineSeries<AccelerometerReadings, double>(
                  color: Colors.yellow,
                  dataSource: yaxis, 
                  xValueMapper: (AccelerometerReadings yspots, _) => yspots.time, 
                  yValueMapper: (AccelerometerReadings yspots, _) => yspots.reading,
                 ),
                 LineSeries<AccelerometerReadings, double>(
                   color: Colors.red,
                   dataSource: zaxis,
                   xValueMapper: (AccelerometerReadings zspots, _) => zspots.time, 
                   yValueMapper: (AccelerometerReadings zspots, _) => zspots.reading,
                 )
              ],
            ),
          ),
      );
  }

  @override
  void initState() {
    super.initState();
    setData();
  }
}