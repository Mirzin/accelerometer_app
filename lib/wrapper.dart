import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_app/screens/home/home.dart';

class Wrapper extends HookWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      FirebaseAuth.instance.authStateChanges().first.then((event) {
        if (event == null) {
          Navigator.of(context).popAndPushNamed("login");
        } else {
          Navigator.of(context)
              .popAndPushNamed("home");
        }
      });
    }, []);
    return const HomePage();
  }
}
