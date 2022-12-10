import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_wallet/LogScreen/signing.dart';


// ignore: camel_case_types
class intros extends StatefulWidget {
  const intros({Key? key}) : super(key: key);

  @override
  State<intros> createState() => _introsState();
}

// ignore: camel_case_types
class _introsState extends State<intros> {
  var loader = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/wallet.json', onLoaded: (val) {
              setState(() {
                loader = false;
              });
            }),
            const SizedBox(
              height: 50,
            ),
            loader
                ? const SizedBox()
                : signer(
                    context,
                    "Create Account",
                    Colors.white,
                    const Color.fromRGBO(141, 52, 242, 1),
                    const Color.fromRGBO(0, 125, 254, 1),2,
                  ),
            const SizedBox(
              height: 25,
            ),
            loader
                ? const SizedBox()
                : signer(
                    context,
                    "Login",
                    Colors.white70,
                    const Color.fromRGBO(32, 34, 68, 1),
                    const Color.fromRGBO(32, 34, 68, 1),2),
          ],
        ),
      ),
    );
  }


  }

Padding signer(BuildContext context, String name, Color color, Color grad1,
    Color grad2,double width) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50.0),
    child: Container(
      width: MediaQuery.of(context).size.width /width,
      height: MediaQuery.of(context).size.width / 7.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [grad1, grad2],
          )),
      child: MaterialButton(
          onPressed: () async {
            if (name.compareTo("Create Account") == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const signingIn(checker: true)));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const signingIn(checker: false)));
            }
          },
          elevation: 5,
          child: Center(
              child: Text(
                name,
                style: TextStyle(color: color, fontSize: 18,fontWeight: FontWeight.w600),
              ))),
    ),
  );
}
