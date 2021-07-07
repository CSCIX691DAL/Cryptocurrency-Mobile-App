import 'package:flutter/material.dart';
import 'package:crpto_app_mobile/buy_page.dart';
import 'home_page.dart';

class BuyPage extends StatelessWidget {

  final Map currency;

  BuyPage(this.currency);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Buy Coins"),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 26.0,
              ),
            ),

            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right:20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                        Icons.more_vert
                    ),
                  )
              ),
            ]
        ),


        body: Center(
            child: Column( children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(30.0),
                  width: 350,
                  height: 200,
                  child: CircleAvatar(
                      child: Image.network(currency['image']),
                  ),
              ),

              Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.black54.withOpacity(0.1),
                  width: 175,
                  height: 60,
                  child: Center(
                      child: Text(currency['name'],
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
                  child: Text("Buy " + currency['name'] + " Currency"),
                  onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          title: const Text('Crypto Currency Purchased!')
                      )
                  )
              )
            ]
            )
        )


    );
  }
}



