import 'dart:math';

import 'package:flutter/material.dart';

class taskCreation extends StatefulWidget {
  const taskCreation({Key? key}) : super(key: key);

  @override
  State<taskCreation> createState() => _taskCreationState();
}

class _taskCreationState extends State<taskCreation> {
  TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backColor(),
      ),
      backgroundColor: backColor(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Enter your tasks",
                hintStyle: TextStyle(color: Colors.black45),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width/3,
              height: MediaQuery.of(context).size.width / 7.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                    color:Colors.transparent,
                border: Border.all(color: Colors.black45)
            ),
            child:  MaterialButton(
              onPressed: (){},
              child: Row(
                children: const [
                  Icon(Icons.date_range,color: Colors.black45,),
                  SizedBox(width: 5,),
                  Text("Today",style: TextStyle(color: Colors.black45),),
                ],
              ),
            ),
            ),

          ],
        ),
      ),
    );
  }

  Color backColor() => const Color(0xFFF7E9E0);
//const Color(0xFFEBEDEE);
}
