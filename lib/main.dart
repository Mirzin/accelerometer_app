import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_app/screens/authenticate/login.dart';
import 'package:sensors_app/screens/authenticate/register.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: AppBarTheme(
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
          backgroundColor: Colors.grey[50],
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      //initialRoute: "graph",
      routes: {
        "/": (ctx) => const Wrapper(),
        "home": (ctx) => const HomePage(),
        "readings": (ctx) => const Readings(),
        "viewgraph": (ctx) =>const ViewGraph(),
        "register": (ctx) => const RegisterPage(),
        "login": (ctx) => const Login(),
        "profile": (ctx) => const ProfilePage(),
      },
    );
  }
}
