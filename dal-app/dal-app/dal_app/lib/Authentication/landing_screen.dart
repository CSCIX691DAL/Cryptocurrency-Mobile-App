import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  final List currencies;
  HomePage(this.currencies);

  // const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}


class _HomePageState extends State<HomePage> {

  late List currencies;
  //final List<MaterialColor> _colors = [Colors.amber, Colors.blueGrey, Colors.indigo];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Cryptocurrency Tracker"),
        ),
        body: _cryptoWidget()
    );
  }

  Widget _cryptoWidget(){
    return Container(
                child: ListView.builder(
                  itemCount: 1,
                  // ignore: unnecessary_new, unnecessary_new, unnecessary_new
                  itemBuilder: (BuildContext context, int index){
                    final Map currency = widget.currencies[index];
                    //final MaterialColor = _colors[index % _colors.length];
                    return _getCurrencyInfo(currency);
                    },
                )
    );
  }

  Widget _getCurrencyInfo (Map currency) {
    return Stack(
      children: <Widget>[
        Container (
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
                height: 70,
                width: 70,
                child: Image.network(currency['image'])
            ),
        ),

        Positioned (
            top: 40,
            right: 100,
            child: SizedBox (
              child: Text(
                  currency['name'] + " - " + currency['symbol'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35.0,
                  )
              )
            ),
        ),

        Positioned (
          top: 110,
          left: 25,
          child: Text(
            "1 " + currency['symbol'] + " = " + currency['current_price'].toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            )
          )
        ),
      ],
      overflow: Overflow.visible,
    );
  }

  Widget _getSubtitleText(String priceUSD, String percentageChange){
    TextSpan priceTextWidget = TextSpan(
        text: "\$$priceUSD\n", style: TextStyle(color: Colors.black));

    String percentageChangeText = "$percentageChange%";
    TextSpan percentageChangeTextWidget;

    if(double.parse(percentageChange) >0.0){
      percentageChangeTextWidget = TextSpan(text: percentageChangeText, style: new TextStyle(color: Colors.green));
    } else{
      percentageChangeTextWidget = TextSpan(text: percentageChangeText, style: new TextStyle(color: Colors.red));
    }

    return RichText(
        text: TextSpan(
            children: [priceTextWidget, percentageChangeTextWidget]
        )
    );
  }
}