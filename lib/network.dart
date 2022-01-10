import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
const upperUrl='https://rest.coinapi.io/v1/exchangerate/';
const apikey='BEB62D38-614C-4FA5-B40F-D8CD9D871B7F';

class Network{



  Future<dynamic> getCurrencyExchangeRate(String toCoin,String fromCoin) async{
      String url='$upperUrl$toCoin/$fromCoin?apikey=$apikey';
      var response= await http.get(url);
      print(response.statusCode);
      var responseString=convert.jsonDecode(response.body);
      print(responseString["rate"]);
      return responseString["rate"];
  }


}