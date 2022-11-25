import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class signingIn extends StatefulWidget {
  final bool checker;
  const signingIn({Key? key,required this.checker}) : super(key: key);

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
  IconData passwordVisibility = Icons.visibility_off;



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromRGBO(22,23,48,1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Text("Welcome Back!",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),
            const Text("Please login to your account.",style: TextStyle(color: Color.fromRGBO(143,142,154,1),fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(51,54,67,1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: TextFormField(
                  decoration:  InputDecoration(
                    contentPadding:const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Email",
                    labelText: "Email",
                    hintStyle: fieldStyle(true),
                    labelStyle: fieldStyle(false),
                    enabledBorder:const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:BorderSide(color: Colors.transparent,
                        width: 3.5,
                      ),
                    ),
                  ),
                  cursorColor: Colors.white70,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  style: const TextStyle(color: Colors.white,),
                  validator: (value) {
                    if (value!.contains(" ",0)) {
                      return "Enter an email without space";
                    } else if(RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return null;
                    }else{
                      return "Enter valid Email";
                    }
                  },

                ),
              ),
            )
          ],
        ),
      )
    );
  }

  TextStyle  fieldStyle(bool bold) {
    Color t = Colors.white70;
    if(bold){t = Colors.white24;}
    return  TextStyle(
                  fontWeight: FontWeight.bold,
                  color: t,
                  fontSize: 14,
                );
  }
}
