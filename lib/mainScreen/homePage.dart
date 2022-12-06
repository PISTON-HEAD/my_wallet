// ignore: duplicate_ignore
// ignore_for_file: camel_case_types, duplicate_ignore, avoid_print, no_logic_in_create_state

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_wallet/lottie/intro.dart';
import 'package:my_wallet/mainScreen/taskCreator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:transition/transition.dart';
// ignore: camel_case_types

class homeScreen extends StatefulWidget {
  final String userName;
  const homeScreen({Key? key,  required this.userName})
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



  void scrollUp(){
    sController.animateTo(sController.position.minScrollExtent, duration: const Duration(milliseconds: 1700), curve: Curves.fastOutSlowIn,);
  }

  void taskScroller(){
    taskController.animateTo(taskController.position.minScrollExtent, duration: const Duration(milliseconds: 1700), curve: Curves.fastOutSlowIn);
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
  int count=0;
  var clickId = "";
  var strCategory = "";


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
                onTap: () async {
                  SharedPreferences shared =await SharedPreferences.getInstance();
                  shared.setString("LoggedIn", "false");
                  auth.signOut().then((value) => {
                  Navigator.pushReplacement(
                  context,
                  Transition(
                  child:  const  intros(),
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
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        times = DateTime.now().toString().substring(0,21);
                        FirebaseFirestore.instance.collection("User Tasks").doc("$userName||${auth.currentUser!.uid}").collection("Categories").doc(times).set({
                          "Category":"Create Category",
                          "Created Time":times,
                          "Tasks":[],
                          "Checker":[],
                          "Count":0,
                          "id":times,
                          "Category Count":categoryCounter,
                          "Completed Tasks":0,
                        });
                        scrollUp();
                        setState(() {
                          idCat =times;
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
                    const SizedBox(
                      width: 8,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("User Tasks").doc("$userName||${auth.currentUser!.uid}").collection("Categories").snapshots(),
                      builder: (context, snapshot) {
                        return SingleChildScrollView(
                          child: SizedBox(
                            height: 125,
                            width: MediaQuery.of(context).size.width/1.4,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                                controller: sController,
                                itemBuilder: (context, index) {
                                  count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                                  clickId = count==0?"":snapshot.data?.docs[count-1]["id"];
                                  categoryCounter = snapshot.hasData ?snapshot.data!.docs.length - index:0;
                                  return AnimatedContainer(
                                    curve: Curves.fastOutSlowIn,
                                    margin:const EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: drawerColor(),
                                        borderRadius: BorderRadius.circular(20)),
                                    duration: const Duration(seconds: 2),
                                    child: MaterialButton(
                                      onLongPress: (){
                                      //edit the name
                                        idCat = snapshot.data?.docs[count - 1-index]["id"];
                                        catController.text = "";
                                      showDialog(context: context, builder: ((context) {
                                        return  AlertDialog(

                                          actions: [
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                             children: [
                                               TextButton(
                                                   onPressed: (){
                                                     var deleteCat = idCat;
                                                     idCat="";
                                                     Timer(const Duration(milliseconds: 400), () {
                                                       FirebaseFirestore.instance.collection("User Tasks").doc("$userName||${auth.currentUser!.uid}").collection("Categories").doc(deleteCat).delete();
                                                     });
                                                     Navigator.of(context).pop();
                                                   }, child: const Text("Delete",style: TextStyle(color: Colors.redAccent),)),
                                               TextButton(
                                                   onPressed: (){
                                                     catController.text==""?Navigator.of(context).pop():FirebaseFirestore.instance.collection("User Tasks").doc("$userName||${auth.currentUser!.uid}").collection("Categories").doc(idCat).update(
                                                         {
                                                           "Category":catController.text,
                                                         });
                                                     catController.text = "";
                                                     Navigator.of(context).pop();
                                                   }, child: const Text("Change",style: TextStyle(color: Colors.white),)),

                                             ],
                                           )

                                          ],
                                          backgroundColor: Colors.black87,
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          title: const Text("Change Category Name",style: TextStyle(color: Colors.white),),
                                          elevation: 20,
                                          content: TextField(
                                            controller: catController,
                                            autocorrect: true,
                                            autofocus: true,
                                            style:const  TextStyle(color: Colors.white70),
                                            decoration:const  InputDecoration(
                                              hintText: "Enter name",
                                              labelText: "Name",
                                              hintStyle: TextStyle(color: Colors.white60),
                                            ),
                                            onSubmitted: (value){
                                              FirebaseFirestore.instance.collection("User Tasks").doc("$userName||${auth.currentUser!.uid}").collection("Categories").doc(idCat).update(
                                                  {
                                                    "Category":value,
                                                  });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          contentTextStyle:const TextStyle(color: Colors.white70),
                                        );
                                      }));
                                      },
                                      onPressed: (){
                                        setState(() {
                                          idCat = snapshot.data?.docs[count - 1-index]["id"];
                                        });
                                      },
                                      shape:  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                      padding:const EdgeInsets.only(
                                          left: 15,right: 15, top: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${snapshot.data!.docs[count-1-index]["Count"]} Task",
                                            style: categoryStyle(Colors.white54,FontWeight.bold,18),
                                          ),
                                          const SizedBox(height: 5,),
                                          Text(
                                            "${snapshot.data!.docs[count - 1 -index]["Category"]}  ",
                                            style: categoryStyle(const Color.fromRGBO(255, 255, 255, 0.8),FontWeight.bold,21),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 55),
                                            child: Center(
                                              child: ProgressBar(
                                                gradient:  LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors:snapshot.data!.docs.length - index %2==0? [Colors.teal, Colors.tealAccent]:[Colors.orange, Colors.deepOrangeAccent],
                                                ),
                                                backgroundColor: Colors.black38,
                                                value:snapshot.data!.docs[count-1-index]["Count"]>=1? snapshot.data!.docs[count-1-index]["Completed Tasks"]/snapshot.data!.docs[count-1-index]["Count"]:0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                    ),
                  ],
                ),
                 SizedBox(height:MediaQuery.of(context).size.width/12,),
                 Text("Today's Tasks",style: sideHeadingStyle(drawerTextColor, FontWeight.w600, 20),),
                const SizedBox(height:15,),
                if (idCat=="") const SizedBox() else StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("User Tasks").doc("$userName||${auth.currentUser!.uid}").collection("Categories").where("id",isEqualTo:idCat).snapshots(),
                  builder: (context, snapshot) {
                    return SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height/2.19,
                        child: ListView.builder(
                            controller: taskController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.hasData && snapshot.data!.docs[0]["Count"]>=1? snapshot.data!.docs[0]["Count"]: 0,
                            itemBuilder: (context,index){
                          return
                            Padding(
                            padding: const EdgeInsets.only(top: 4.0,bottom: 4,right: 20),
                            child: ListTile(
                              title: Text("${snapshot.data!.docs[0]["Tasks"][index]}",style:snapshot.data!.docs[0]["Checker"][index]?const TextStyle(color: Colors.white54,fontSize: 18,fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough): categoryStyle(const Color.fromRGBO(255, 255, 255, 0.95), FontWeight.w600, 18),),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              tileColor: drawerColor(),
                              leading: CustomCheckBox(
                                checkedFillColor: index % 2 == 0 ?foreColor: floatColor()  ,
                                uncheckedFillColor: drawerColor(),
                                uncheckedIconColor: drawerColor(),
                                borderColor: index % 2 == 0
                                    ? foreColor: floatColor()  ,
                                checkBoxSize: 20,
                                borderWidth: 2,
                                borderRadius: 20,
                                shouldShowBorder: true,
                                checkedIconColor: Colors.white,
                                splashColor: Colors.transparent,
                                splashRadius: 20,
                                tooltip: "Complete or redo task",
                                value: snapshot.data!.docs[0]["Checker"][index],
                                onChanged: (val){
                                 var checker = snapshot.data!.docs[0]["Checker"];
                                 var completed = snapshot.data!.docs[0]["Completed Tasks"];
                                 checker[index] = !checker[index];
                                 checker[index]?FirebaseFirestore.instance.collection("User Tasks").doc("$userName||${auth.currentUser!.uid}").collection("Categories").doc(idCat).update(
                                     {
                                       "Checker":checker,
                                       "Completed Tasks":completed+1,
                                     }):FirebaseFirestore.instance.collection("User Tasks").doc("$userName||${auth.currentUser!.uid}").collection("Categories").doc(idCat).update(
                                     {
                                       "Checker":checker,
                                       "Completed Tasks":completed-1,
                                     });
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }
                ),
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
                  child:  const taskCreation(),
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

  TextStyle sideHeadingStyle(Color txtColor,FontWeight txtWeight,int txtSize){
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

/*
// ignore: duplicate_ignore
// ignore_for_file: camel_case_types, duplicate_ignore, avoid_print, no_logic_in_create_state

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_wallet/mainScreen/taskCreator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
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



  void scrollUp(){
    sController.animateTo(sController.position.minScrollExtent, duration: const Duration(milliseconds: 1700), curve: Curves.fastOutSlowIn,);
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
                const SizedBox(
                  height: 25,
                ),
                Row(

                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        scrollUp();
                        setState(() {
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
                    SingleChildScrollView(
                      child: SizedBox(
                        height: 125,
                        width: MediaQuery.of(context).size.width/1.48,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: categoryCounter,
                            controller: sController,
                            reverse: false,
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
                                      "${categoryCounter-index-1} Tasks",
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
                      ),
                    )
                  ],
                ),
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
                  child:  const taskCreation(),
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
 */
