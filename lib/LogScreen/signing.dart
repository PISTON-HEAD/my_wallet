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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text(checker.toString(),style: const TextStyle(color:Colors.lightBlue),),),
    );
  }
}
