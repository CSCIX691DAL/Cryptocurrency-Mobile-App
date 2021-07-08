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
          title: Text("  Currency                                      Account:"),
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
}