import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.1.100:8080';
class BaseClients {

  var client = http.Client();
  Future<dynamic> get(String api)async{
    var url = Uri.parse(baseUrl+api);
    var response = await client.get(url);
    if(response.statusCode  == 200){
      return response.body;
    }else{
      //exception
      print("Error");
    }

  }

}