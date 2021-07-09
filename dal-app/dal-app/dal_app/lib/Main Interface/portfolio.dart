import 'package:dal_app/Main%20Interface/profile_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dal_app/Main%20Interface/buy_page.dart';
import 'package:dal_app/Main%20Interface/main.dart';
import 'package:dal_app/Main%20Interface/portfolio.dart';
import 'package:dal_app/Main%20Interface/sell_page.dart';
import 'package:dal_app/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'home_page.dart';
class PortfolioPage extends StatefulWidget {

  final List currencies;
  PortfolioPage(this.currencies);

  // const HomePage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => new _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {

  List currencies;
  //final List<MaterialColor> _colors = [Colors.amber, Colors.blueGrey, Colors.indigo];

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Portfolio",
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
          body: _cryptoWidget()
      ),
    );
  }

  Widget _cryptoWidget(){
    return Container(
        child: new Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                  itemCount: widget.currencies.length,
                  // ignore: unnecessary_new, unnecessary_new, unnecessary_new
                  itemBuilder: (BuildContext context, int index){
                    final Map currency = widget.currencies[index];
                    //final MaterialColor = _colors[index % _colors.length];
                    return _getListItemUi(currency);
                  },
                )
            )
          ],
        ));
  }

  ListTile _getListItemUi(Map currency){
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(currency['image']),
      ),

      title: Text(currency['name'],
          style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: _userAmount(currency['current_price'].toString(), currency['symbol'].toString()),
      subtitle: Text("Current Price: \$" + currency['current_price'].toString() + " USD"),

      isThreeLine: true,
    );
  }

  Widget _userAmount(String priceUSD, String symbol){
    TextSpan priceTextWidget = TextSpan(
        text: "2.3 " + symbol + "    ", style: TextStyle(color: Colors.black, fontSize: 22));

    return RichText(
        text: TextSpan(
            children: [priceTextWidget]
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