import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Connect extends StatefulWidget {
  const Connect({Key? key}) : super(key: key);

  @override
  _ConnectState createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  String secondstext = '';
  late String name;
  Timer? timer;
  late StreamSubscription stream;
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    name = arguments['name'];
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Text(
          secondstext,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    stream.cancel();
  }

  void _getData() {
    final db = FirebaseDatabase.instance.reference();
    final uid = FirebaseAuth.instance.currentUser!.uid.toString();
    int timerseconds = 0;
    stream = db.child("users/$uid/runtime").onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value);
        final period = data['period'];
        final int time = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, data['hour'], data['minute']).millisecondsSinceEpoch;
        // if (data['hour'] < TimeOfDay.now().hour ||
        //     (data['hour'] == TimeOfDay.now().hour &&
        //         data['minute'] < TimeOfDay.now().minute)) {
        // } else if (data['hour'] > TimeOfDay.now().hour &&
        //     data['minute'] < TimeOfDay.now().minute) {
        //   minutes = (60 - DateTime.now().minute) + data['minute'] - 1 as int;
        //   seconds = 60 - DateTime.now().second;
        //   timerseconds = (minutes * 60) + seconds;
        // } else {
        //   hours = data['hour'] - DateTime.now().hour;
        //   minutes = (hours * 60) + (data['minute'] - DateTime.now().minute - 1)
        //       as int;
        //   seconds = 60 - DateTime.now().second;
        //   timerseconds = (minutes * 60) + seconds;
        // }
        timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          timerseconds = time - DateTime.now().millisecondsSinceEpoch;
          if (timerseconds < 0) {
            timer.cancel();
          }
          if (mounted) {
            setState(() {
              secondstext = (timerseconds/1000).toString();
            });
          }
        });
        Future.delayed(
            Duration(milliseconds: time - DateTime.now().millisecondsSinceEpoch), () {
          Navigator.popAndPushNamed(context, "sfgraph", arguments: {
            "period": period,
            'name' : name,
          });
        });
      }
    });
  }
}
