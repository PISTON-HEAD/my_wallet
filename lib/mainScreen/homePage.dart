// ignore: duplicate_ignore
// ignore_for_file: camel_case_types, duplicate_ignore, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:my_wallet/mainScreen/taskCreator.dart';
import 'package:transition/transition.dart';
// ignore: camel_case_types

class homeScreen extends StatefulWidget {
  final String userName;
  const homeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState(userName);
}

class _homeScreenState extends State<homeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String userName;
  _homeScreenState(this.userName);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  fileChoser() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    var myImage = File(pickedFile!.path);
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${auth.currentUser!.displayName}/${auth.currentUser!.uid}")
        .child("Profile Picture");
    var upload = ref.putFile(myImage);
    var imageUrl = await FirebaseStorage.instance
        .ref()
        .child("${auth.currentUser!.displayName}/${auth.currentUser!.uid}")
        .child("Profile Picture")
        .getDownloadURL();
    auth.currentUser!
        .updatePhotoURL(imageUrl)
        .whenComplete(() => {setState(() {})});
  }

  var foreColor = Color(0xFF2F394E);
  //const Color(0xFF394F89);
  //const Color.fromRGBO(53, 80, 161, 1);
  //const Color.fromRGBO(18, 32, 103, 1);
  var isChecked = false;
  var arr = [
    "Try a large text and see what happens, now we need to add category then add the task page then order them , h man gong to be difficult",
    "Gokul",
    "KJ",
    "Divv",
    "mAAMAN",
    "Siva",
    "CT",
    "Kundan",
    "Dutt",
    "Vaishnav",
    "Dasappan",
    "Rikku",
  ];
  var arrBool = [
    true,
    false,
    true,
    false,
    true,
    true,
    true,
    false,
    false,
    true,
    true,
    false
  ];

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
          textColor: Colors.white60,
          iconColor: drawerIconColor(),
          //Colors.tealAccent,//Colors.lightBlue,
          selectedTileColor: Colors.grey,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  width: 140.0,
                  height: 140.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 44.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: auth.currentUser!.photoURL != null
                      ? GestureDetector(
                          onLongPress: () {
                            fileChoser();
                            setState(() {});
                          },
                          child: Image.network(
                            "${auth.currentUser!.photoURL}",
                            fit: BoxFit.cover,
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            fileChoser();
                            setState(() {});
                          },
                          child: Image.asset(
                            "assets/default.png",
                            fit: BoxFit.cover,
                          ))),
              Text(
                userName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 25,
              ),
              ListTile(
                onTap: () {},
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
                onTap: () {},
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: Text('Wallet', style: buildTextStyle),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.settings_outlined),
                title: Text('Settings', style: buildTextStyle),
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: foreColor,
        appBar: AppBar(
          actions: const [
            // advanced Search
          ],
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
        body: StreamBuilder(
            stream:FirebaseFirestore.instance
                .collection("User Tasks")
                .doc("${auth.currentUser!.displayName}||${auth.currentUser!.uid}").collection("Category").doc("Welcome").snapshots(),
            builder: (context, snapshot) {
            //print(snapshot.data?.data()?.entries.first.value[0]);
              //print(snapshot.data?.data()?["Checker"][0]);
              return
                ListView.builder(
                  itemCount: snapshot.data?.data()?["Count"],
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 3.5),
                      decoration: BoxDecoration(
                        //border: Border.all(color: index % 2 == 0 ? floatColor() : foreColor,width: 1,strokeAlign: StrokeAlign.outside),
                        borderRadius: BorderRadius.circular(15),
                        color: drawerColor(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ListTile(
                          leading: CustomCheckBox(
                            checkedFillColor:
                                index % 2 == 0 ? floatColor() : foreColor,
                            uncheckedFillColor: drawerColor(),
                            uncheckedIconColor: drawerColor(),
                            checkBoxSize: 22,
                            borderWidth: 2,
                            shouldShowBorder: true,
                            checkedIconColor: Colors.white,
                            splashColor: Colors.transparent,
                            //activeColor: index % 2 == 0 ? floatColor() : foreColor,
                            borderColor: index % 2 == 0
                                ? floatColor()
                                : snapshot.data?.data()?["Checker"][index] != true
                                    ? Colors.blueGrey
                                    : foreColor,
                            borderRadius: 20,
                            //shape: const CircleBorder(),
                            value: snapshot.data?.data()?["Checker"][index],
                            onChanged: (bool? value) {
                              var checker;
                              FirebaseFirestore.instance.collection("User Tasks")
                                  .doc("${auth.currentUser!.displayName}||${auth.currentUser!.uid}").collection("Category").doc("Welcome").get().then((value) =>
                              {
                                checker = value["Checker"],
                                checker[index]=!checker[index],
                                FirebaseFirestore.instance.collection("User Tasks")
                                    .doc("${auth.currentUser!.displayName}||${auth.currentUser!.uid}").collection("Category").doc("Welcome").update(
                                    {
                                  "Checker":checker,
                              }),
                              });
                            },
                          ),
                          title: Text(
                            snapshot.data?.data()?["Task List"][index],
                            style: TextStyle(
                                color: !snapshot.data?.data()?["Checker"][index]
                                    ? Colors.white
                                    : Colors.white38,
                                decoration: !snapshot.data?.data()?["Checker"][index]
                                    ? null
                                    : TextDecoration.lineThrough,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  });
            }),
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
            Navigator.push(
                context,
                Transition(
                  child: const taskCreation(),
                  transitionEffect: TransitionEffect.FADE,
                ));
          },
        ),
      ),
    );
  }

  Color drawerIconColor() => const Color.fromRGBO(72, 91, 145, 3);

  Color drawerColor() => const Color.fromRGBO(20, 30, 54, 1);
  //const Color.fromRGBO(24, 20, 77, 1);
  //const Color.fromRGBO(4, 25, 87, 1);
  //const Color(0xFF0F102C);

  Color floatColor() => Colors.purpleAccent;

  TextStyle get buildTextStyle =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w400);

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
/*
// ignore: duplicate_ignore
// ignore_for_file: camel_case_types, duplicate_ignore, avoid_print

import 'dart:io';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:my_wallet/mainScreen/taskCreator.dart';
import 'package:transition/transition.dart';
// ignore: camel_case_types

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  fileChoser() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    var myImage = File(pickedFile!.path);
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${auth.currentUser!.displayName}/${auth.currentUser!.uid}")
        .child("Profile Picture");
    var upload = ref.putFile(myImage);
    var imageUrl = await FirebaseStorage.instance
        .ref()
        .child("${auth.currentUser!.displayName}/${auth.currentUser!.uid}")
        .child("Profile Picture")
        .getDownloadURL();
    auth.currentUser!
        .updatePhotoURL(imageUrl)
        .whenComplete(() => {setState(() {})});
  }

  var foreColor =  Color(0xFF2F394E);
  //const Color(0xFF394F89);
  //const Color.fromRGBO(53, 80, 161, 1);
  //const Color.fromRGBO(18, 32, 103, 1);
  var isChecked = false;
  var arr = ["Try a large text and see what happens, now we need to add category then add the task page then order them , h man gong to be difficult",
    "Gokul",
    "KJ",
    "Divv",
    "mAAMAN",
    "Siva",
    "CT",
    "Kundan",
    "Dutt",
    "Vaishnav",
    "Dasappan",
    "Rikku",
  ];
  var arrBool = [
    true,
    false,
    true,
    false,
    true,
    true,
    true,
    false,
    false,
    true,
    true,
    false
  ];

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor:  drawerColor(),
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
          textColor: Colors.white60,
          iconColor: drawerIconColor(),
          //Colors.tealAccent,//Colors.lightBlue,
          selectedTileColor: Colors.grey,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  width: 140.0,
                  height: 140.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 44.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: auth.currentUser!.photoURL != null
                      ? GestureDetector(
                          onLongPress: () {
                            fileChoser();
                            setState(() {});
                          },
                          child: Image.network(
                            "${auth.currentUser!.photoURL}",
                            fit: BoxFit.cover,
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            fileChoser();
                            setState(() {});
                          },
                          child: Image.asset(
                            "assets/default.png",
                            fit: BoxFit.cover,
                          ))),
              Text(
                "${auth.currentUser!.displayName}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 25,
              ),
              ListTile(
                onTap: () {},
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
                onTap: () {},
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: Text('Wallet', style: buildTextStyle),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.settings_outlined),
                title: Text('Settings', style: buildTextStyle),
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: foreColor,
        appBar: AppBar(
          actions: const [
            // advanced Search

          ],
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
        body: ListView.builder(
            itemCount: arrBool.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 3.5),
                decoration: BoxDecoration(
                  //border: Border.all(color: index % 2 == 0 ? floatColor() : foreColor,width: 1,strokeAlign: StrokeAlign.outside),
                  borderRadius: BorderRadius.circular(15),
                  color: drawerColor(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ListTile(
                    leading: CustomCheckBox (
                      checkedFillColor: index % 2 == 0 ? floatColor() : foreColor,
                        uncheckedFillColor: drawerColor(),
                        uncheckedIconColor: drawerColor(),
                        checkBoxSize: 22,
                        borderWidth: 2,
                      shouldShowBorder: true,
                      checkedIconColor: Colors.white,
                      splashColor: Colors.transparent,
                      //activeColor: index % 2 == 0 ? floatColor() : foreColor,
                      borderColor:
                        index % 2 == 0 ? floatColor() :arrBool[index] != true?Colors.blueGrey:foreColor,
                      borderRadius: 20,
                      //shape: const CircleBorder(),
                      value: arrBool[index],
                      onChanged: (bool? value) {
                        setState(() {
                          if (arrBool[index]) {
                            arrBool[index] = false;
                          } else {
                            arrBool[index] = true;
                          }
                        });
                      },
                    ),
                    title: Text(
                      arr[index],
                      style: TextStyle(
                          color:
                              !arrBool[index] ? Colors.white : Colors.white38,
                          decoration: !arrBool[index]
                              ? null
                              : TextDecoration.lineThrough,
                          fontWeight: FontWeight.w500,
                      fontSize: 16),
                    ),

                  ),
                ),
              );
            }),
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
            Navigator.push(
                context,
                Transition(
                    child: const taskCreation(), transitionEffect: TransitionEffect.FADE,
                ));       },
        ),
      ),
    );
  }

  Color drawerIconColor() => const Color.fromRGBO(72, 91, 145, 3);

  Color drawerColor() => const Color.fromRGBO(20, 30, 54, 1);
  //const Color.fromRGBO(24, 20, 77, 1);
      //const Color.fromRGBO(4, 25, 87, 1);
      //const Color(0xFF0F102C);

  Color floatColor() =>  Colors.purpleAccent;

  TextStyle get buildTextStyle =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w400);

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}

 */
