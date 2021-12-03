import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sensors_app/screens/authenticate/login.dart';
import 'package:sensors_app/screens/authenticate/register.dart';
import 'package:sensors_app/screens/home/accgraph.dart';
import 'package:sensors_app/screens/home/home.dart';
import 'package:sensors_app/screens/home/profile.dart';
import 'package:sensors_app/screens/home/readings.dart';
import 'package:sensors_app/screens/home/viewgraph.dart';
import 'package:sensors_app/wrapper.dart';
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      //initialRoute: "graph",
      routes: {
        "/" : (ctx) => const Wrapper(),
        "home" : (ctx) => const HomePage(),
        "sfgraph" : (ctx) => AccGraph(),
        "readings" : (ctx) => Readings(),
        "viewgraph" : (ctx) =>const ViewGraph(),
        "register" : (ctx) => const RegisterPage(),
        "login" : (ctx) => const Login(),
        "profile" : (ctx) => const ProfilePage(),
      },
    );
  }
}