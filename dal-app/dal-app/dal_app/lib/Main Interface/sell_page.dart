import 'package:dal_app/Main%20Interface/profile_page.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'buy_page.dart';
import 'dart:convert';
import 'package:dal_app/Main%20Interface/buy_page.dart';
import 'package:dal_app/Main%20Interface/portfolio.dart';
import 'package:dal_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'home_page.dart';

class SellPage extends StatefulWidget {
  VoidCallback advance;

  SellPage({@required this.advance});

  @override
  State<StatefulWidget> createState() => _SellPageState(advance: advance);
}

class _SellPageState extends State<SellPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  VoidCallback advance;

  bool get wantKeepAlive => true;

  _SellPageState({@required this.advance});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Sell Coins",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
                size: 40,
              ),
              onSelected: choiceAction ,
              itemBuilder: (BuildContext context){
                return Constants.choices.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),


        body: Center(
            child: Column( children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(30.0),
                  width: 350,
                  height: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: ExactAssetImage("assets/images/Bitcoin-Logo.png"),
                          fit: BoxFit.fill
                      )
                  )
              ),

              Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.black54.withOpacity(0.1),
                  width: 175,
                  height: 60,
                  child: Center(
                      child: Text("Bitcoin -- BTC",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.withOpacity(1.0),
                            fontSize: 25,
                          )
                      )
                  )
              ),

              Container(
                margin: const EdgeInsets.all(10.0),
                color: Colors.black54.withOpacity(0.1),
                width: 175,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "\$0.00",
                  ),
                ),
              ),

              OutlinedButton(
                  child: Text("Sell Crypto Currency"),
                  onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          title: const Text('Crypto Currency Sold!')
                      )
                  )
              )
            ]
            )
        )


    );
  }
  void choiceAction (String choice){
    if(choice == Constants.sellPage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SellPage()),
      );
    }
    else if(choice == Constants.buyPage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BuyPage()),
      );
    }
    else if(choice == Constants.profilePage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
    else if(choice == Constants.homePage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SwapToHome()),
      );
    }
    else if(choice == Constants.portfolioPage){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SwapToPortfolio()),
      );
    }
  }

  SwapToPortfolio() async {
    List currencies = await getCurrencies();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PortfolioPage(currencies)),
    );
  }
  SwapToHome() async {
    List currencies = await getCurrencies();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(currencies)),
    );
  }
  Future<List> getCurrencies() async{
    String cryptoUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false";
    http.Response response = await http.get(Uri.parse(cryptoUrl));
    return jsonDecode(response.body);
  }
}