import 'package:dal_app/ProportionalSizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DalLogoBackButton extends StatelessWidget {

  VoidCallback onPressed;
  DalLogoBackButton({@required this.onPressed});
  @override
  Widget build(BuildContext context) {
    ProportionalSizes sizeManager = new ProportionalSizes(context);

    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back),
          SizedBox(width: 10,),
          SizedBox(
            height: sizeManager.titleSize + 10,
            child: Image.asset("assets/dallogosmall.png"),
          ),
        ],
      ),
    );
  }

}