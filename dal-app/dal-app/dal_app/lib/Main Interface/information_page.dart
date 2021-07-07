
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  //const InformationPage({Key? key}) : super(key: key);

  final Map currency;

  InformationPage(this.currency);

  //get low_24h => currency['low_24h'].toString();
  @override
  Widget build(BuildContext context) {
    String lp = currency['low_24h'].toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Traders'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 25),
            _cardWidget(),
            SizedBox(
              height: 15,
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Text('Day'),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey[200],
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      child: Text('Day')),
                  // Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  //     decoration: BoxDecoration(
                  //         color: Colors.blueGrey[200],
                  //         borderRadius: BorderRadius.all(Radius.circular(30))
                  //     ),
                  //     child: Text('Week')),
                  // Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  //     decoration: BoxDecoration(
                  //         color: Colors.blueGrey[200],
                  //         borderRadius: BorderRadius.all(Radius.circular(30))
                  //     ),
                  //     child: Text('Month')),
                  // Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  //     decoration: BoxDecoration(
                  //         color: Colors.blueGrey[200],
                  //         borderRadius: BorderRadius.all(Radius.circular(30))
                  //     ),
                  //     child: Text('Year')),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),

            Card(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            _dot(color: Colors.pink),
                            Text('Lower: \$'+currency['low_24h'].toStringAsPrecision(5), style: const TextStyle(
                                fontSize: 16,
                                //fontWeight: FontWeight.bold,
                                color: Colors.black
                            )),
                          ],),
                          Row(children: [
                            _dot(color: Colors.pink),
                            Text('Higher: \$'+currency['high_24h'].toStringAsPrecision(5), style: TextStyle(
                                fontSize: 16,
                                //fontWeight: FontWeight.bold,
                                color: Colors.black
                            )),
                          ],
                          )

                        ],
                      ),

                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/6,
                      child: Stack(
                        children: [
                          LineChart(
                            sampleData(),
                          ),
                          // Positioned(
                          //   bottom:   0,
                          //   left: 10,
                          //     child: Row(
                          //       children: [
                          //         _dot(color: Colors.orangeAccent, size: 15),
                          //         Text("1"+currency['name']+"=\$"+currency['current_price'].toString(),
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 20))
                          //       ],
                          //     ),
                          // )
                        ],
                      ),
                    )
                  ],
                )
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(child: _actionButton(
                    text: 'Buy',
                    color: Colors.blue
                )),
                SizedBox(width: 20,),
                Expanded(child: _actionButton(
                    text: 'Sell',
                    color: Colors.pink
                )),
              ],
            )
          ],
        ),
      ),

    );
  }

  LineChartData sampleData(){
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
          bottomTitles: SideTitles(showTitles: false),
          leftTitles: SideTitles(showTitles: false)),
      borderData: FlBorderData(show: false),
      maxX: 5,
      maxY: 4,
      minY: 0,
      lineBarsData: linesBarData(),
    );
  }

  List<LineChartBarData> linesBarData(){
    return[
      LineChartBarData(
          spots: [
            FlSpot(1, 2),
            FlSpot(2, 2.8),
            FlSpot(3, 4),
            FlSpot(4, 3.4),
            FlSpot(5, 2),
          ],
          isCurved: true,
          colors: const [Colors.orangeAccent,],
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: true,)
      )
    ];
  }

  _dot({Color color = Colors.black, double size = 10}){
    return Container(
      margin: EdgeInsets.all(10),
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: color,
        ),
      ),
    );
  }

  _actionButton({
    Color color = Colors.green,
    String text
  }){
    return Card(

      child: Column(
        children: [
          ClipOval(
            child: Material(
              color: color,
              child: InkWell(
                splashColor: Colors.black,
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.attach_money, color: Colors.white, size: 25,),
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Text('$text', style: TextStyle(fontSize: 24, color: Colors.black),)
        ],
      ),
    );
  }

  _cardWidget(){
    return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(currency['image'], width: 50,),
                const SizedBox(width: 20,),
                Expanded(child: Text(currency['name'], style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                ),)
                ),
                Text(currency['symbol'], style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,

                ),)
              ],

            ),
            SizedBox(
              height: 20,
            ),
            Positioned(
              bottom:   0,
              left: 10,
              child: Row(
                children: [

                  Text("1"+currency['name']+"=\$"+currency['current_price'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20))
                ],
              ),
            ),
            Row(
              children: [
                Text('Market Cap = '+'\$'+ currency['market_cap'].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,

                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                //   decoration: BoxDecoration(
                //     color: Colors.green,
                //     borderRadius: BorderRadius.all(Radius.circular(30)),
                //   ),
                //   child: Text(
                //       currency['price_change_percentage_24h'].toString(),
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold),
                //     ),
                //   ),


              ],


            ),
            Center(child: Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.black45,))
          ],
        )
    );
  }
}
