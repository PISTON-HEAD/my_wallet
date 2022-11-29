import 'package:flutter/material.dart';

class taskCreation extends StatefulWidget {
  const taskCreation({Key? key}) : super(key: key);

  @override
  State<taskCreation> createState() => _taskCreationState();
}

class _taskCreationState extends State<taskCreation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backColor(),
      ),
      backgroundColor: backColor(),
      body: Column(),
    );
  }

  Color backColor() => const Color(0xFFF7E9E0);
//const Color(0xFFEBEDEE);
}
