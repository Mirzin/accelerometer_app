// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterPage extends StatefulHookWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> f = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final confirmPassword = useTextEditingController();
    final errorText = useState<String?>(null);
    return Form(
      key: f,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Sign Up",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  obscureText: true,
                  controller: password,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    obscureText: true,
                    controller: confirmPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (cp) {
                      if (cp == password.value.text)
                        return null;
                      else
                        return "Both Passwords must match";
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
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
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () async {
                      if (f.currentState?.validate() == false) {
                        errorText.value = "Form is invalid";
                        return;
                      }
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email.value.text,
                                password: password.value.text);
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email.value.text,
                            password: password.value.text);
                        Navigator.pushNamedAndRemoveUntil(
                            context, "home", (_) => false);
                      } catch (e) {
                        if (e is FirebaseAuthException)
                          errorText.value = e.code.replaceAll('-', " ");
                        else
                          errorText.value = "Register Failed";
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
