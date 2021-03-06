// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_app/screens/authenticate/register.dart';
import 'package:sensors_app/screens/home/home.dart';
import 'package:sensors_app/services/custompageroute.dart';

class Login extends HookWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final errorText = useState<String?>(null);
    var _opacity = useState<double>(0);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +
                AppBar().preferredSize.height),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Login",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  controller: email,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) {
                    if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email ?? ""))
                      return null;
                    else
                      return "Email is invalid";
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Password",
                  ),
                  controller: password,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) {
                    if ((password ?? "").length >= 8)
                      return null;
                    else
                      return "Password must be min 8 characters long";
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Opacity(
                  opacity: _opacity.value,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ValueListenableBuilder(
                  valueListenable: errorText,
                  builder:
                      (BuildContext context, String? value, Widget? child) {
                    if (value != null)
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 17),
                        ),
                      );
                    else
                      return Container();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 40, left: 15, right: 15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () async {
                      if (email.value.text == "" || password.value.text == "") {
                        errorText.value = "Email/Password cannot be Empty";
                        return;
                      }
                      try {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _opacity.value = 1;
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email.value.text.trim(),
                            password: password.value.text);
                        _opacity.value = 0;
                        Navigator.of(context)
                            .pushReplacement(CustomPageRoute(child: const HomePage()));
                      } catch (e) {
                        _opacity.value = 0;
                        if (e is FirebaseAuthException)
                          errorText.value = e.code.replaceAll('-', ' ');
                        else
                          errorText.value = "Unknown Error";
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(
                  height: 5,
                  thickness: 1,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    const Text(
                      "Don't have an Account ? ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(CustomPageRoute(child: const RegisterPage()));
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
