// ignore: duplicate_ignore
// ignore_for_file: camel_case_types, duplicate_ignore, avoid_print

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:my_wallet/mainScreen/taskCreate.dart';
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

  String userName;
  _homeScreenState(this.userName);

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

  var drawerTextColor = Colors.white60;

  var foreColor = const Color(0xFF2F394E);
  //const Color(0xFF394F89);
  //const Color.fromRGBO(53, 80, 161, 1);
  //const Color.fromRGBO(18, 32, 103, 1);
  var isChecked = false;

  int categoryCounter = 0;

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
                const SizedBox(
                  height: 25,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FloatingActionButton(
                        onPressed: () {setState(() {
                          categoryCounter++;
                        });},
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
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: categoryCounter,
                            itemBuilder: (context, index) {
                              return Container(
                                margin:const EdgeInsets.symmetric(horizontal: 5),
                                padding:const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                decoration: BoxDecoration(
                                    color: drawerColor(),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      "$index Tasks",
                                      style: categoryStyle(Colors.white54,FontWeight.bold,18),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      "Business          ",
                                      style: categoryStyle(Colors.white,FontWeight.bold,20),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
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

  TextStyle categoryStyle(Color txtColor,FontWeight txtWeight,int txtSize) {
    return  TextStyle(
                                      color: txtColor,
                                      fontWeight: txtWeight,
                                      letterSpacing: 0.7,
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
