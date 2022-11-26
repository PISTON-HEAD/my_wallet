// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
FirebaseAuth auth = FirebaseAuth.instance;

Future signUp(String email, String password, String username) async {
  try{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final fireUser = credential.user;
    final logger = (await FirebaseFirestore.instance.collection("User Data").where("id",isEqualTo: fireUser?.uid).get()).docs;
    if(logger.isEmpty){
      print("New User -- Initializing Cloud Collection....");
      fireUser!.updateDisplayName(username);
      FirebaseFirestore.instance.collection("User Data").doc(fireUser.uid).set({
        "Name":username,
        "Email":email,
        "Password":password,
        "Created Time":DateTime.now().toString().substring(0,16),
        "Last SignedIn":DateTime.now().toString().toString().substring(0,16),
        "id":fireUser.uid,
      });
      sharedPreferences.setString("id",fireUser.uid);
      sharedPreferences.setString("Name",username);
      sharedPreferences.setString("Email",email);
      sharedPreferences.setString("Password",password);
      sharedPreferences.setString("LoggedIn", "true");
    }

  }catch(error){
    print("error found: $error");
    if(error.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account."){
      return error.toString();
    }else{
      return null;
    }

  }
}