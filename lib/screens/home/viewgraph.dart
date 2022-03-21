import 'package:flutter/material.dart';
import 'package:sensors_app/services/excel.dart';
import 'package:sensors_app/widgets/showgraph.dart';
import 'dart:math';

class ViewGraph extends StatelessWidget {
  const ViewGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
    );
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final id = arguments["id"].toString();
    final List<double> xaxis = [], yaxis = [], zaxis = [], time = [];
    for (dynamic point in arguments["xspots"]) {
      xaxis.add(double.parse(point.toString()));
    }
    for (dynamic point in arguments["yspots"]) {
      yaxis.add(double.parse(point.toString()));
    }
    for (dynamic point in arguments["zspots"]) {
      zaxis.add(double.parse(point.toString()));
    }
    for (dynamic point in arguments["time"]) {
      time.add(double.parse(point.toString()));
    }
    final double cpa = zaxis.reduce(max);
    final double cpca = sqrt((xaxis.reduce(max) * xaxis.reduce(max)) + (yaxis.reduce(max) * yaxis.reduce(max)) + (zaxis.reduce(max) * zaxis.reduce(max)));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(arguments['id']),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text("x"),
                SizedBox(width: 2),
                CircleAvatar(backgroundColor: Colors.blue, radius: 7),
                SizedBox(width: 5),
                Text("y"),
                SizedBox(width: 2),
                CircleAvatar(backgroundColor: Colors.yellow, radius: 7),
                SizedBox(width: 5),
                Text("z"),
                SizedBox(width: 2),
                CircleAvatar(backgroundColor: Colors.red, radius: 7),
              ],
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ShowGraph(
                  xspots: xaxis, yspots: yaxis, zspots: zaxis, time: time)),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
                columnSpacing: 15,
                headingRowHeight: 50,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Use',
                      style: style,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Permitted Peak \nAcceleration\n (m/s\u00B2)',
                      style: style,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Calculated Peak \nAcceleration\n (m/s\u00B2)',
                      style: style,
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      const DataCell(Text("Residential\n/Office")),
                      const DataCell(Text("0.05")),
                      DataCell(Text(cpa.toStringAsFixed(2))),
                    ],
                  ),
                  DataRow(
                    cells: [
                      const DataCell(Text("Commercial")),
                      const DataCell(Text("0.18")),
                      DataCell(Text(cpa.toStringAsFixed(2))),
                    ],
                  ),
                  const DataRow(
                    cells: [
                      DataCell(Text(
                        "Use",
                        style: style,
                      )),
                      DataCell(Text(
                        "Permissible Peak \n Combined Acceleration (m/s\u00B2)",
                        style: style,
                      )),
                      DataCell(Text(
                        "Calculated Peak \n Combined Accelration (m/s\u00B2)",
                        style: style,
                      )),
                    ],
                  ),
                  DataRow(
                    cells: [
                      const DataCell(Text("Residential\n/Office")),
                      const DataCell(Text("0.15")),
                      DataCell(Text(cpca.toStringAsFixed(2))),
                    ],
                  ),
                  DataRow(
                    cells: [
                      const DataCell(Text("Commercial")),
                      const DataCell(Text("0.25")),
                      DataCell(Text(cpca.toStringAsFixed(2))),
                    ],
                  ),
                ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              child: const Text("Create Excel Sheet"),
              onPressed: () {
                createExcel(xaxis, yaxis, zaxis, time, id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
