import 'package:flutter/material.dart';

class SellPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Sell Coins"),
            leading: GestureDetector(
              onTap: () { /* Write listener code here */ },
              child: Icon(
                Icons.menu,  // add custom icons also
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
}