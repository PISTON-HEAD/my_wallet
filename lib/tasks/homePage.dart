// ignore: duplicate_ignore
// ignore_for_file: camel_case_types, duplicate_ignore, avoid_print, no_logic_in_create_state

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_wallet/lottie/intro.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:my_wallet/tasks/taskCreator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:transition/transition.dart';
// ignore: camel_case_types

class homeScreen extends StatefulWidget {
  final String userName;
  const homeScreen({Key? key, required this.userName})
      : super(key: key) // ignore: no_logic_in_create_state
  ;

  @override
  State<homeScreen> createState() => _homeScreenState(userName);
}

class _homeScreenState extends State<homeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController sController = ScrollController();
  ScrollController taskController = ScrollController();
  String userName;
  _homeScreenState(this.userName);
  String idCat = "";

  var times = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var fileLoader = false;
  fileChoser() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    var myImage = File(pickedFile!.path);
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${auth.currentUser!.displayName}/${auth.currentUser!.uid}")
        .child("Profile Picture");
    String imageUrl;
    ref.putFile(myImage).whenComplete(() async => {
          imageUrl = await FirebaseStorage.instance
              .ref()
              .child(
                  "${auth.currentUser!.displayName}/${auth.currentUser!.uid}")
              .child("Profile Picture")
              .getDownloadURL(),
          auth.currentUser!.updatePhotoURL(imageUrl).whenComplete(() => {
                setState(() {
                  fileLoader = false;
                }),
              })
        });
  }

  void scrollUp() {
    sController.animateTo(
      sController.position.minScrollExtent,
      duration: const Duration(milliseconds: 1700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void taskScroller() {
    taskController.animateTo(taskController.position.minScrollExtent,
        duration: const Duration(milliseconds: 1700),
        curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var drawerTextColor = Colors.white60;

  var foreColor = const Color(0xFF2F394E);
  //const Color(0xFF394F89);
  //const Color.fromRGBO(53, 80, 161, 1);
  //const Color.fromRGBO(18, 32, 103, 1);
  var isChecked = false;

  int categoryCounter = 0;
  int count = 0;
  var clickId = "";
  var strCategory = "";
  var animatedContainerWidth = 50.0;
  var snaps = "";
  var taskIdCreator = "";
  bool activateWallet = false;
  bool activateHome = true;

  TextEditingController catController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: drawerColor(),
      controller: _advancedDrawerController,
      animationDuration: const Duration(milliseconds: 350),
      animateChildDecoration: true,
      animationCurve: Curves.easeInCubic,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: drawerTextColor,
          iconColor: drawerIconColor(),
          selectedTileColor: Colors.grey,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(fit: StackFit.passthrough, children: [
                fileLoader
                    ? Positioned(
                        child: Container(
                        margin: const EdgeInsets.only(
                          top: 24.0,
                          bottom: 44.0,
                        ),
                        height: 145,
                        width: 145,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child:
                            const CircularProgressIndicator(color: Colors.grey),
                      ))
                    : Container(
                        width: 140.0,
                        height: 140.0,
                        margin: const EdgeInsets.only(
                          top: 24.0,
                          bottom: 30.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: auth.currentUser!.photoURL != null
                            ? GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    fileLoader = true;
                                  });
                                  fileChoser();
                                },
                                child: Image.network(
                                  "${auth.currentUser!.photoURL}",
                                  fit: BoxFit.cover,
                                ),
                              )
                            : GestureDetector(
                                onLongPress: () async {
                                  setState(() {
                                    fileLoader = true;
                                  });
                                  fileChoser().printInfo;
                                  setState(() {
                                    fileLoader = false;
                                  });
                                },
                                child: Image.asset(
                                  "assets/default.png",
                                  fit: BoxFit.cover,
                                ))),
              ]),
              Text(
                userName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 25,
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    activateWallet = false;
                  });
                },
                leading: const Icon(Icons.home_outlined),
                title: Text(
                  'Home',
                  style: buildTextStyle,
                ),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.account_circle_outlined),
                title: Text(
                  'Profile',
                  style: buildTextStyle,
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    activateWallet = true;
                  });
                },
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: Text('Wallet', style: buildTextStyle),
              ),
              ListTile(
                onTap: () async {
                  SharedPreferences shared =
                      await SharedPreferences.getInstance();
                  shared.setString("LoggedIn", "false");
                  auth.signOut().then((value) => {
                        Navigator.pushReplacement(
                            context,
                            Transition(
                              child: const intros(),
                              curve: Curves.easeIn,
                              transitionEffect: TransitionEffect.FADE,
                            )),
                      });
                },
                leading: const Icon(Icons.settings_outlined),
                title: Text('Settings', style: buildTextStyle),
              ),
            ],
          ),
        ),
      ),
      child: activateWallet
          ? const Scaffold()
          : Scaffold(
              backgroundColor: foreColor,
              appBar: AppBar(
                backgroundColor: foreColor,
                elevation: 0,
                leading: IconButton(
                  onPressed: _handleMenuButtonPressed,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: _advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          value.visible ? Icons.clear : Icons.menu,
                          key: ValueKey<bool>(value.visible),
                        ),
                      );
                    },
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's up, $userName!",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Text(
                      "CATEGORIES",
                      style: TextStyle(
                          color: drawerTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 28,
                    ),
                    Row(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            times = DateTime.now().toString().substring(0, 21);
                            FirebaseFirestore.instance
                                .collection("User Tasks")
                                .doc("$userName||${auth.currentUser!.uid}")
                                .collection("Categories")
                                .doc(times)
                                .set({
                              "Category": "Create Category",
                              "Created Time": times,
                              "Tasks": [],
                              "Checker": [],
                              "Count": 0,
                              "id": times,
                              "Category Count": categoryCounter,
                              "Completed Tasks": 0,
                            });
                            scrollUp();
                            setState(() {
                              idCat = times;
                              taskIdCreator = idCat;
                            });
                          },
                          elevation: 10,
                          backgroundColor: drawerColor(),
                          tooltip: "CREATE CATEGORIES",
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Icon(
                                Icons.add,
                                size: 35,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 65,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("User Tasks")
                                .doc("$userName||${auth.currentUser!.uid}")
                                .collection("Categories")
                                .snapshots(),
                            builder: (context, snapshot) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.width / 3.157,
                                width: MediaQuery.of(context).size.width / 1.4,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.hasData
                                        ? snapshot.data!.docs.length
                                        : 0,
                                    controller: sController,
                                    itemBuilder: (context, index) {
                                      count = snapshot.hasData
                                          ? snapshot.data!.docs.length
                                          : 0;
                                      clickId = count == 0
                                          ? ""
                                          : snapshot.data?.docs[count - 1]
                                              ["id"];
                                      taskIdCreator = taskIdCreator == ""
                                          ? snapshot.data
                                              ?.docs[count - 1 - index]["id"]
                                          : taskIdCreator;
                                      categoryCounter = snapshot.hasData
                                          ? snapshot.data!.docs.length - index
                                          : 0;
                                      return AnimatedContainer(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        curve: Curves.fastOutSlowIn,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: drawerColor(),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        duration: const Duration(seconds: 2),
                                        child: MaterialButton(
                                          onLongPress: () {
                                            //edit the name
                                            idCat = snapshot.data
                                                ?.docs[count - 1 - index]["id"];
                                            catController.text = "";
                                            showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return AlertDialog(
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                var deleteCat =
                                                                    idCat;
                                                                idCat = "";
                                                                Timer(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            400),
                                                                    () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "User Tasks")
                                                                      .doc(
                                                                          "$userName||${auth.currentUser!.uid}")
                                                                      .collection(
                                                                          "Categories")
                                                                      .doc(
                                                                          deleteCat)
                                                                      .delete();
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent),
                                                              )),
                                                          TextButton(
                                                              onPressed: () {
                                                                catController.text ==
                                                                        ""
                                                                    ? Navigator.of(
                                                                            context)
                                                                        .pop()
                                                                    : FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "User Tasks")
                                                                        .doc(
                                                                            "$userName||${auth.currentUser!.uid}")
                                                                        .collection(
                                                                            "Categories")
                                                                        .doc(
                                                                            idCat)
                                                                        .update({
                                                                        "Category":
                                                                            catController.text,
                                                                      });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                catController
                                                                    .text = "";
                                                              },
                                                              child: const Text(
                                                                "Change",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                    backgroundColor:
                                                        Colors.black87,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                    title: const Text(
                                                      "Change Category Name",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    elevation: 20,
                                                    content: TextField(
                                                      controller: catController,
                                                      autocorrect: true,
                                                      autofocus: true,
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.white70),
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: "Enter name",
                                                        labelText: "Name",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.white60),
                                                      ),
                                                      onSubmitted: (value) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "User Tasks")
                                                            .doc(
                                                                "$userName||${auth.currentUser!.uid}")
                                                            .collection(
                                                                "Categories")
                                                            .doc(idCat)
                                                            .update({
                                                          "Category": value,
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    contentTextStyle:
                                                        const TextStyle(
                                                            color:
                                                                Colors.white70),
                                                  );
                                                }));
                                          },
                                          onPressed: () {
                                            print(snapshot.data!.docs.length);
                                            setState(() {
                                              idCat = snapshot.data
                                                      ?.docs[count - 1 - index]
                                                  ["id"];
                                              taskIdCreator = idCat;
                                            });
                                          },
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${snapshot.data!.docs[count - 1 - index]["Count"]} Task",
                                                style: categoryStyle(
                                                    Colors.white54,
                                                    FontWeight.bold,
                                                    18),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    50,
                                              ),
                                              Text(
                                                "${snapshot.data!.docs[count - 1 - index]["Category"]}  ",
                                                style: categoryStyle(
                                                    const Color.fromRGBO(
                                                        255, 255, 255, 0.8),
                                                    FontWeight.bold,
                                                    19),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    8.1,
                                              ),
                                              Center(
                                                child: ProgressBar(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    stops: const [0.26, 0.9],
                                                    colors: (index) % 2 == 0
                                                        ? [
                                                            Colors.teal,
                                                            Colors.cyanAccent
                                                          ]
                                                        : [
                                                            Colors
                                                                .deepOrangeAccent,
                                                            Colors.orange,
                                                          ],
                                                  ),
                                                  backgroundColor:
                                                      Colors.black38,
                                                  value: snapshot.data!.docs[count -
                                                              1 -
                                                              index]["Count"] >=
                                                          1
                                                      ? snapshot.data!.docs[
                                                                  count - 1 - index][
                                                              "Completed Tasks"] /
                                                          snapshot.data!.docs[
                                                              count -
                                                                  1 -
                                                                  index]["Count"]
                                                      : 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 12,
                    ),
                    Text(
                      "Today's Tasks",
                      style: sideHeadingStyle(
                          drawerTextColor, FontWeight.w600, 20),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 40,
                    ),
                    if (idCat == "")
                      const SizedBox()
                    else
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("User Tasks")
                                .doc("$userName||${auth.currentUser!.uid}")
                                .collection("Categories")
                                .where("id", isEqualTo: idCat)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return SingleChildScrollView(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2.19,
                                  child: ListView.builder(
                                      controller: taskController,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.hasData &&
                                              snapshot.data!.docs[0]["Count"] >=
                                                  1
                                          ? snapshot.data!.docs[0]["Count"]
                                          : 0,
                                      itemBuilder: (context, index) {
                                        taskIdCreator = idCat;
                                        return Dismissible(
                                          key: Key(snapshot.data!.docs[0]
                                              ["Tasks"][snapshot.data!.docs[0]
                                                  ["Count"] -
                                              1 -
                                              index]),
                                          onDismissed: (value) {
                                            var tasks =
                                                snapshot.data!.docs[0]["Tasks"];
                                            var checker = snapshot.data!.docs[0]
                                                ["Checker"];
                                            var completed = snapshot.data!
                                                .docs[0]["Completed Tasks"];
                                            if (checker[snapshot.data!.docs[0]
                                                    ["Count"] -
                                                1 -
                                                index]) {
                                              completed -= 1;
                                            }
                                            tasks.remove(snapshot.data!.docs[0]
                                                ["Tasks"][snapshot.data!.docs[0]
                                                    ["Count"] -
                                                1 -
                                                index]);
                                            checker.remove(snapshot
                                                    .data!.docs[0]["Checker"][
                                                snapshot.data!.docs[0]
                                                        ["Count"] -
                                                    1 -
                                                    index]);
                                            FirebaseFirestore.instance
                                                .collection("User Tasks")
                                                .doc(
                                                    "$userName||${auth.currentUser!.uid}")
                                                .collection("Categories")
                                                .doc(idCat)
                                                .update({
                                              "Tasks": tasks,
                                              "Checker": checker,
                                              "Count": snapshot.data!.docs[0]
                                                      ["Count"] -
                                                  1,
                                              "Completed Tasks": completed,
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4.0, bottom: 4, right: 20),
                                            child: ListTile(
                                              title: Text(
                                                "${snapshot.data!.docs[0]["Tasks"][snapshot.data!.docs[0]["Count"] - 1-index]}",
                                                style: snapshot.data!.docs[0]
                                                        ["Checker"][snapshot
                                                            .data!
                                                            .docs[0]["Count"] -
                                                        1 -
                                                        index]
                                                    ? const TextStyle(
                                                        color: Colors.white54,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough)
                                                    : categoryStyle(
                                                        const Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.95),
                                                        FontWeight.w600,
                                                        17),
                                              ),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.0))),
                                              tileColor: drawerColor(),
                                              leading: CustomCheckBox(
                                                checkedFillColor: index % 2 == 0
                                                    ? foreColor
                                                    : floatColor(),
                                                uncheckedFillColor:
                                                    drawerColor(),
                                                uncheckedIconColor:
                                                    drawerColor(),
                                                borderColor: index % 2 == 0
                                                    ? foreColor
                                                    : floatColor(),
                                                checkBoxSize: 20,
                                                borderWidth: 2,
                                                borderRadius: 20,
                                                shouldShowBorder: true,
                                                checkedIconColor: Colors.white,
                                                splashColor: Colors.transparent,
                                                splashRadius: 20,
                                                tooltip:
                                                    "Complete or redo task",
                                                value: snapshot.data!.docs[0]
                                                    ["Checker"][snapshot.data!
                                                        .docs[0]["Count"] -
                                                    1 -
                                                    index],
                                                onChanged: (val) {
                                                  var checker = snapshot
                                                      .data!.docs[0]["Checker"];
                                                  var completed =
                                                      snapshot.data!.docs[0]
                                                          ["Completed Tasks"];
                                                  checker[snapshot.data!.docs[0]
                                                          ["Count"] -
                                                      1 -
                                                      index] = !checker[snapshot
                                                          .data!
                                                          .docs[0]["Count"] -
                                                      1 -
                                                      index];
                                                  checker[snapshot.data!.docs[0]
                                                              ["Count"] -
                                                          1 -
                                                          index]
                                                      ? FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "User Tasks")
                                                          .doc(
                                                              "$userName||${auth.currentUser!.uid}")
                                                          .collection(
                                                              "Categories")
                                                          .doc(idCat)
                                                          .update({
                                                          "Checker": checker,
                                                          "Completed Tasks":
                                                              completed + 1,
                                                        })
                                                      : FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "User Tasks")
                                                          .doc(
                                                              "$userName||${auth.currentUser!.uid}")
                                                          .collection(
                                                              "Categories")
                                                          .doc(idCat)
                                                          .update({
                                                          "Checker": checker,
                                                          "Completed Tasks":
                                                              completed - 1,
                                                        });
                                                },
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  var tasks = snapshot
                                                      .data!.docs[0]["Tasks"];
                                                  var checker = snapshot
                                                      .data!.docs[0]["Checker"];
                                                  tasks.remove(snapshot.data!
                                                      .docs[0]["Tasks"][snapshot
                                                          .data!
                                                          .docs[0]["Count"] -
                                                      1 -
                                                      index]);
                                                  checker.remove(snapshot.data!
                                                          .docs[0]["Checker"][
                                                      snapshot.data!.docs[0]
                                                              ["Count"] -
                                                          1 -
                                                          index]);
                                                  snapshot.data!.docs[0]
                                                              ["Checker"][
                                                          snapshot.data!.docs[0]
                                                                  ["Count"] -
                                                              1 -
                                                              index]
                                                      ? FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "User Tasks")
                                                          .doc(
                                                              "$userName||${auth.currentUser!.uid}")
                                                          .collection(
                                                              "Categories")
                                                          .doc(idCat)
                                                          .update({
                                                          "Tasks": tasks,
                                                          "Checker": checker,
                                                          "Count": snapshot
                                                                      .data!
                                                                      .docs[0]
                                                                  ["Count"] -
                                                              1,
                                                          "Completed Tasks": snapshot
                                                                      .data!
                                                                      .docs[0][
                                                                  "Completed Tasks"] -
                                                              1
                                                        })
                                                      : FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "User Tasks")
                                                          .doc(
                                                              "$userName||${auth.currentUser!.uid}")
                                                          .collection(
                                                              "Categories")
                                                          .doc(idCat)
                                                          .update({
                                                          "Tasks": tasks,
                                                          "Checker": checker,
                                                          "Count": snapshot
                                                                      .data!
                                                                      .docs[0]
                                                                  ["Count"] -
                                                              1,
                                                        });
                                                },
                                                icon: const Icon(Icons.delete),
                                                color: Colors.red[400],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              );
                            }),
                      ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: floatColor(),
                splashColor: Colors.white70,
                elevation: 25,
                highlightElevation: 20,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () {
                  setState(() {
                    idCat = taskIdCreator;
                  });
                  Navigator.push(
                      context,
                      Transition(
                        child: taskCreation(
                            snapshot: FirebaseFirestore.instance
                                .collection("User Tasks")
                                .doc("$userName||${auth.currentUser!.uid}")
                                .collection("Categories")
                                .where("id", isEqualTo: idCat)
                                .snapshots(),
                            taskId: taskIdCreator),
                        transitionEffect: TransitionEffect.FADE,
                      ));
                },
              ),
            ),
    );
  }

  TextStyle categoryStyle(Color txtColor, FontWeight txtWeight, int txtSize) {
    return TextStyle(
      color: txtColor,
      fontWeight: txtWeight,
      letterSpacing: 0.7,
      fontSize: txtSize.toDouble(),
    );
  }

  TextStyle sideHeadingStyle(
      Color txtColor, FontWeight txtWeight, int txtSize) {
    return TextStyle(
      color: txtColor,
      fontWeight: txtWeight,
      letterSpacing: 0.1,
      fontSize: txtSize.toDouble(),
    );
  }

  Color drawerIconColor() => const Color.fromRGBO(72, 91, 145, 3);

  Color drawerColor() => const Color.fromRGBO(20, 30, 54, 1);
  //const Color.fromRGBO(24, 20, 77, 1);
  //const Color.fromRGBO(4, 25, 87, 1);
  //const Color(0xFF0F102C);

  Color floatColor() => Colors.purpleAccent;
  TextStyle get buildTextStyle =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
/*
 Wrap(
                      spacing: 10,
                      direction: Axis.horizontal,
                      children:List.generate(3, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: drawerColor(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:  Card(
                            color: Colors.transparent,
                            elevation: 10,
                            child: Column(
                              children: [
                                Text("data  dhfdshf iefesh fdsnf hdsufu"),
                                Text("Data")
                              ],
                            ),
                          )
                        );
                      }),
                    ),
 */
