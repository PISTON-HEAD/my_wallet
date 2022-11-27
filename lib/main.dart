// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/lottie/intro.dart';
import 'package:my_wallet/mainScreen/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
  String? logger = "null";
  logger = sharedPreferences.getString("LoggedIn");
  runApp(MyApp(logger: logger,));
}

class MyApp extends StatelessWidget {
  final String? logger;
  const MyApp({super.key, required this.logger});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your personalized Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blueGrey,
      ),
      home:logger == null || logger=="false"? const intros():const homeScreen(),
    );
  }
}
