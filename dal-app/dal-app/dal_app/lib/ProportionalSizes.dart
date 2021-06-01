import 'package:flutter/cupertino.dart';

class ProportionalSizes {

  //If you're wondering what this is, I am too. This was supposed to be a class
  //that would control font sizes based on the screen size, but I ran out of time
  //to implement it in every view. It is currently only used in the authentication
  //screens (Sign in, Sign Up). Would be nice in the future to merge this with TextStyles class
  //and have responsive titles, font sizes, margins, etc, based on screen size.

  BuildContext context;
  double titleSize = 40;
  double subtitleSize = 24;
  double labelSize = 20;
  double padding = 40;

  ProportionalSizes(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if(height < 700) {
      titleSize = 30;
      subtitleSize = 18;
      labelSize = 14;
      padding = 20;
    }
  }
}