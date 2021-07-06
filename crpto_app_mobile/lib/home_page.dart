import 'package:flutter/material.dart';

import 'information_page.dart';

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
          title: Text("Cryptocurrency App"),
        ),
        body: _cryptoWidget()
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
      trailing: _getSubtitleText(currency['current_price'].toString(), currency['price_change_percentage_24h'].toString()),
      subtitle: Text(currency['symbol']),

      isThreeLine: true,

      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InformationPage(currency))
        );
      },

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
