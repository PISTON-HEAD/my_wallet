// ignore_for_file: must_be_immutable, no_logic_in_create_state, prefer_typing_uninitialized_variables, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../notification/manager.dart';

// ignore: camel_case_types
class taskCreation extends StatefulWidget {
  final String taskId;
  var snapshot;

  taskCreation({super.key, required this.taskId, required this.snapshot});

  @override
  State<taskCreation> createState() => _taskCreationState(taskId, snapshot);
}

class _taskCreationState extends State<taskCreation> {
  TextEditingController controller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController taskScroller = ScrollController();
  void scrollUp() {
    taskScroller.animateTo(
      taskScroller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1700),
      curve: Curves.fastOutSlowIn,
    );
  }

  var taskId;
  var taskAdded = false;
  var newTaskList = [];
  var snapshot;

  _taskCreationState(this.taskId, this.snapshot);

  DateTime dateTime = DateTime.now();

  NotifyManager manager = NotifyManager();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keeper();
    manager.initializeNotification();
  }

  var tasks = [];
  var checker = [];
  var totalCount = 0;
  var category = "";
  keeper() {
    FirebaseFirestore.instance
        .collection("User Tasks")
        .doc("${auth.currentUser!.displayName}||${auth.currentUser!.uid}")
        .collection("Categories")
        .where("id", isEqualTo: taskId)
        .get()
        .then((value) => {
              tasks = value.docs[0]["Tasks"],
              checker = value.docs[0]["Checker"],
              totalCount = value.docs[0]["Count"],
              category = value.docs[0]["Category"],
            });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    uploadTask();
  }

  uploadTask() {
    if (controller.text.isNotEmpty || taskAdded == true) {
      if(controller.text.isNotEmpty){
        tasks.add(controller.text);
        checker.add(false);
      }
      totalCount = tasks.length;
      FirebaseFirestore.instance
          .collection("User Tasks")
          .doc("${auth.currentUser!.displayName}||${auth.currentUser!.uid}")
          .collection("Categories")
          .doc(taskId)
          .update({
        "Tasks": tasks,
        "Checker": checker,
        "Count": totalCount,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
          title: const Text(""),
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: backColor(),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: IconButton(icon: const Icon(Icons.save_sharp,color: Colors.black54,size: 20),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ),]
      ),
      backgroundColor: backColor(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               SizedBox(height: MediaQuery.of(context).size.width/1.8,
               child: ListView.builder(
                 controller: taskScroller,
                 itemCount: newTaskList.length,
                 itemBuilder: (context, index) {
                 return  Card(
                   margin:const EdgeInsets.symmetric(vertical: 5),
                   elevation: 1,
                   color: Colors.white24,
                   borderOnForeground: true,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(newTaskList[index]),
                   ),
                 );
               },),
               ),
              TextField(
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                    if(controller.text!=""){
                      scrollUp();
                      setState(() {
                        tasks.add(controller.text);
                        checker.add(false);
                        taskAdded=true;
                        newTaskList.add(controller.text);
                        controller.text="";
                      });
                    }
                    }, icon:const Icon(Icons.radio_button_checked),color: Colors.blue,),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: MediaQuery.of(context).size.width / 7.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black45)),
                    child: MaterialButton(
                      onPressed: () async {
                        final date = await PickDate();
                        if (date == null) return;
                        dateTime = date;
                        final timePick = await pickTime();
                        if (timePick == null) return;
                        final newDateTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          timePick.hour,
                          timePick.minute,
                        );
                        manager.scheduleNotification(
                            category, controller.text, newDateTime);
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.date_range,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Schedule Tasks",
                            style: TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Color backColor() => const Color(0xFFF7E9E0);
//const Color(0xFFEBEDEE);
  Future<DateTime?> PickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2022),
      lastDate: DateTime(2026));
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
