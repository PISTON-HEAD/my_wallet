// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:my_wallet/fire_auth/authenticator.dart';

// ignore: camel_case_types
class signingIn extends StatefulWidget {
  final bool checker;
  const signingIn({Key? key, required this.checker}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<signingIn> createState() => _signingInState(checker);
}

// ignore: camel_case_types
class _signingInState extends State<signingIn> {
  bool checker;
  _signingInState(this.checker);

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool seePassword = true;
  bool error = false;
  String errorMsg = "";
  IconData passwordVisibility = Icons.visibility_off;
  int flag = 0;

  signUpUser() {
    if (formKey.currentState!.validate()) {
      signUp(emailController.text, passwordController.text, nameController.text)
          .then((value) => {
                if (value == null)
                  {
                    //Go to next Screen
                    print("User Created Without Interruption.")
                  }
                else
                  {
                    setState(() {
                      error = true;
                      int i;
                      for (i = 1; i < value.toString().length; i++) {
                        if (value.toString()[i] == "]") {
                          break;
                        }
                      }
                      errorMsg = value.toString().substring(i + 2);
                    })
                  }
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(22, 23, 48, 1),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Please login to your account.",
                  style: TextStyle(
                      color: Color.fromRGBO(143, 142, 154, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(51, 54, 67, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: TextFormField(
                      decoration: buildInputDecoration("Email", Icons.email),
                      cursorColor: Colors.white70,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      validator: (value) {
                        if (value!.contains(" ", 0)) {
                          return "Enter an email without space";
                        } else if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return null;
                        } else {
                          return "Enter valid Email";
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                checker
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(51, 54, 67, 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TextFormField(
                            validator: (value) {
                              return value.toString().length <= 4
                                  ? "Minimum character required is 5"
                                  : null;
                            },
                            decoration: buildInputDecoration(
                                "Username", Icons.account_box),
                            cursorColor: Colors.white70,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: nameController,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                checker
                    ? const SizedBox(
                        height: 15,
                      )
                    : const SizedBox(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(51, 54, 67, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextFormField(
                      validator: (value) {
                        String val = value.toString().toLowerCase();
                        int charCounter = 0;
                        if (value!.isEmpty || value.length < 8) {
                          return "character required is 8";
                        } else {
                          for (int i = 0; i < value.length; i++) {
                            if (val.codeUnitAt(i) >= 97 &&
                                val.codeUnitAt(i) <= 122) {}
                            else {
                              charCounter++;
                            }
                          }
                          return charCounter != 0
                              ? null
                              : "Enter characters other than alphabets, ex: 1,/,-...";
                        }
                      },
                      obscureText: seePassword,
                      decoration:
                          buildInputDecoration("Password", passwordVisibility),
                      cursorColor: Colors.white70,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: passwordController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                checker
                    ? const SizedBox(
                        height: 25,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w700,
                                  //decoration: TextDecoration.underline,
                                ),
                              )),
                        ],
                      ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 7.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(141, 52, 242, 1),
                          Color.fromRGBO(0, 125, 254, 1),
                        ],
                      )),
                  child: MaterialButton(
                    onPressed: () {

                      if (checker && flag == 0) {
                        flag = 1;
                        signUpUser();
                      }
                    },
                    child: Text(
                      checker ? "REGISTER NOW" : "LOGIN",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  InputDecoration buildInputDecoration(String text, IconData iconData) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      hintText: text,
      labelText: text,
      hintStyle: fieldStyle(true),
      labelStyle: fieldStyle(false),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 3.5,
        ),
      ),
      suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              if (iconData == Icons.visibility_off) {
                seePassword = false;
                passwordVisibility = Icons.visibility;
              } else if (passwordVisibility == Icons.visibility) {
                seePassword = true;
                passwordVisibility = Icons.visibility_off;
              }
            });
          },
          child: Icon(
            iconData,
            color: Colors.white54,
            size: 25,
          )),
    );
  }

  TextStyle fieldStyle(bool bold) {
    Color t = Colors.white70;
    if (bold) {
      t = Colors.white24;
    }
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: t,
      fontSize: 14,
    );
  }
}
