import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_wallet/client/base_client.dart';

class requestSender extends StatefulWidget {
  const requestSender({Key? key}) : super(key: key);

  @override
  State<requestSender> createState() => _requestSenderState();
}

class _requestSenderState extends State<requestSender> {

  final String serverUrl = 'http://192.168.56.1:8090'; // Replace with your server URL

  Future<void> sendHttpRequest() async {
    final url = Uri.parse('$serverUrl/Philips/IBE/HealthCheck?IP=MSI,DELL'); // Replace with your desired endpoint

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
    } else {
      print('Request failed with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28,31,46,1),

      appBar: AppBar(backgroundColor: Color.fromRGBO(28,31,46,1),),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 50),
            child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              const Text("Choose the service to be provided",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 35),),
              const SizedBox(height: 15,),
            //94,91,245
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButton(context,"Disk Utilization",Color.fromRGBO(51,55,66,1),"assets/diskette.png"),
                buildButton(context,"Service Check",Color.fromRGBO(51,55,66,1),"assets/check.png"),
              ],
            ),
              const SizedBox(height: 15,),
              buildButton(context,"Control Service",Color.fromRGBO(51,55,66,1),"assets/software.png"),
            ],
          )
        )
    );

  }

  Container buildButton(BuildContext context, String name, Color color, String imgPath) {
    return Container(
                padding:const EdgeInsets.symmetric(vertical: 5),
                width: MediaQuery.of(context).size.width/2.3,
                height: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(12),
                    color:color
                ),
                child: MaterialButton(
                  onPressed: (){
                    sendHttpRequest();
                  },
                  child: Column(
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 20),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2.3,
                        height: MediaQuery.of(context).size.width / 3.8,
                        margin: EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imgPath),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}
