import 'package:flutter/material.dart';

class myWallet extends StatefulWidget {
  const myWallet({Key? key}) : super(key: key);

  @override
  State<myWallet> createState() => _myWalletState();
}

class _myWalletState extends State<myWallet> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.width/1.4,
            width: MediaQuery.of(context).size.width,
            decoration:const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(88,56,187,1),
                Color.fromRGBO(141,78,213,1),
              ],stops: [0.4,0.6],begin: Alignment(-1.0, -4.0),
                end: Alignment(1.0, 4.0),),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("CURRENT BALANCE",style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w500)),
                SizedBox(height: 10,),
                Text("42500",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w600),),
                SizedBox(height: 7,),
                Text(DateTime.now().toString().substring(0,11),style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w400),),
                SizedBox(height: 35,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("Income",style:TextStyle(color: Colors.white70,fontWeight: FontWeight.w500)),
                        Text("42500",style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Text(""),
                    Column(
                      children: [
                        Text("Expense",style:TextStyle(color: Colors.white70,fontWeight: FontWeight.w500)),
                        Text("2000",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
