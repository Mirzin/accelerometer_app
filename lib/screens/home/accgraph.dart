import 'package:flutter/material.dart';
import 'package:sensors_app/widgets/sfgraph.dart';

class AccGraph extends StatelessWidget {
  AccGraph({ Key? key }) : super(key: key);

  final appbar = AppBar(
        title: const Text('Sensors'),
        centerTitle: true,
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: SFGraph(appbar : appbar),
    );
  }
}