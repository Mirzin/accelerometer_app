import 'package:flutter/material.dart';
import 'package:sensors_app/services/excel.dart';
import 'package:sensors_app/widgets/showgraph.dart';

class ViewGraph extends StatelessWidget {
  const ViewGraph({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final id = arguments["id"].toString();
    final List<double> xaxis = [], yaxis = [], zaxis = [], time = [];
    for( dynamic point in arguments["xspots"]) {
      xaxis.add(double.parse(point.toString()));
    }
    for( dynamic point in arguments["yspots"]) {
      yaxis.add(double.parse(point.toString()));
    }
    for( dynamic point in arguments["zspots"]) {
      zaxis.add(double.parse(point.toString()));
    }
    for( dynamic point in arguments["time"]) {
      time.add(double.parse(point.toString()));
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(arguments['id']),
      ),
      body: ShowGraph(xspots: xaxis, yspots : yaxis, zspots : zaxis, time : time),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.table_chart),
        onPressed: () {
          createExcel(xaxis, yaxis, zaxis, time, id);     
        },
      ),
    );
  }
}

