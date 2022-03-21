import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_app/screens/authenticate/login.dart';
import 'package:sensors_app/screens/home/home.dart';
import 'package:sensors_app/services/custompageroute.dart';

class Wrapper extends HookWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      FirebaseAuth.instance.authStateChanges().first.then((event) {
        if (event == null) {
          Navigator.of(context)
              .pushReplacement(CustomPageRoute(child: const Login()));
        } else {
          Navigator.of(context)
              .pushReplacement(CustomPageRoute(child: const HomePage()));
        }
      });
      return;
    }, []);
    return const HomePage();
  }
}
