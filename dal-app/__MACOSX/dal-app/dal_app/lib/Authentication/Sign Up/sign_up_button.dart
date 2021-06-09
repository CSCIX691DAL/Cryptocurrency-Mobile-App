import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {

  final VoidCallback action;
  final VoidCallback finalAction;
  final int currentIndex;
  final int maxIndex;

  SignUpButton({@required this.action, @required this.finalAction, @required this.currentIndex, @required this.maxIndex});

  @override
  Widget build(BuildContext context) {
    if(this.currentIndex == this.maxIndex) {
      return MaterialButton(
        onPressed: () => finalAction(),
        color: Theme.of(context).primaryColor,
        child: Text("Done", style: TextStyle(fontSize: 20)),
      );
    } else {
      return OutlinedButton(
          onPressed: () => action(),
          child: Text("Next", style: TextStyle(fontSize: 20)),
      );
    }
  }

}