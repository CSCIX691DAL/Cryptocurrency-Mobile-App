import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './home_page.dart';
import 'dart:async';

void main() async{
  List currencies = await getCurrencies();
  print(currencies);
  runApp(MyApp(currencies));
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  late List _currencies;
  MyApp(this._currencies);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.amber
      ),
      home: HomePage(_currencies),
    );
  }
}





Future<List> getCurrencies() async{
  String cryptoUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false";
  http.Response response = await http.get(Uri.parse(cryptoUrl));
  return jsonDecode(response.body);
}
