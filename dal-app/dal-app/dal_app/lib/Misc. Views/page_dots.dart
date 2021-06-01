import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageDots extends StatelessWidget {

  final int dotCount;
  final int selectedIndex;
  double spacing = 5;

  PageDots({this.dotCount, this.selectedIndex, this.spacing});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for(int i=0; i<dotCount; i++)
          Padding(
            padding: EdgeInsets.only(right: spacing),
            child: Icon(Icons.circle, size: 10, color: i==selectedIndex ? Colors.blueGrey : Colors.black26),
          )
      ],
    );
  }

}