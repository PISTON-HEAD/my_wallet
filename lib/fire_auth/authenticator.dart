import 'package:firebase_auth/firebase_auth.dart';
FirebaseAuth auth = FirebaseAuth.instance;

Future signUp(String email, String password, String username) async {
  try{


  }catch(error){
    print("error found: $error");
    if(error.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account."){
      print("true");
      return error.toString();
    }else{
      return null;
    }

  }
}