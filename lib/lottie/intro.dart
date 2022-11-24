import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: camel_case_types
class intros extends StatefulWidget {
  const intros({Key? key}) : super(key: key);

  @override
  State<intros> createState() => _introsState();
}

// ignore: camel_case_types
class _introsState extends State<intros> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23,23,49,1),
      body: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Lottie.network("https://assets2.lottiefiles.com/packages/lf20_O1b0iWuPju.json"),
          const SizedBox(height: 50,),
          signer(context, "Create Account",Colors.white, const Color.fromRGBO(141,52,242,1),const Color.fromRGBO(0,125,254,1),),
          const SizedBox(height: 25,),
          signer(context, "Login",Colors.white70,const Color.fromRGBO(32,34,68,1),const Color.fromRGBO(32,34,68,1)),
        ],
      ),
    );
  }
  Padding signer(BuildContext context, String name, Color color, Color grad1, Color grad2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Container(
        width: MediaQuery.of(context).size.width/2,
        height: MediaQuery.of(context).size.width/7.5,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
            gradient:  LinearGradient(colors: [
              grad1,grad2
            ],)
        ),
        child:  MaterialButton(
            onPressed: (){
              if(name.compareTo("Create Account")==0){

              }else{

              }
            },
            elevation: 5,
            child: Center(child: Text(name,style: TextStyle(color: color,fontSize: 18),))),),
    );
  }
}


