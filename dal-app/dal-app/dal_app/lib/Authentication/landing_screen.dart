import 'dart:io';

import 'package:dal_app/Authentication/sign_in_screen.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:dal_app/ProportionalSizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  VoidCallback advance;

  LandingScreen({@required this.advance});

  @override
  State<StatefulWidget> createState() => _LandingScreenState(advance: advance);
}

class _LandingScreenState extends State<LandingScreen> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  VoidCallback advance;

  bool get wantKeepAlive => true;

  _LandingScreenState({@required this.advance});

  Future<bool> wait() {
    return Future.delayed(Duration(seconds: 1), () {
      return true;
    });
  }

  Alignment _alignment = FractionalOffset.center;
  bool doneInitalAnimation = false;
  void _changeAlignment() {
    setState(() {
      _alignment = Alignment.topCenter;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 2), () => {
        _changeAlignment()
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ProportionalSizes sizeManager = ProportionalSizes(context);

    return FutureBuilder<Object>(
        future: wait(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return FullScreenLoader();
          }
          return SafeArea(
            child: Stack(
              children: [
                AnimatedContainer(
                  child: SizedBox(height: 400, width: 300 , child: Image.asset("assets/logo.png")),
                  duration: Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  alignment: _alignment,
                  onEnd: () => {
                    this.setState(() {
                      this.doneInitalAnimation = true;
                    })
                  },
                ),
                AnimatedOpacity(
                    duration: Duration(seconds: 1),
                    opacity: this.doneInitalAnimation ? 1 : 0,
                    child: Padding(
                      padding: EdgeInsets.all(sizeManager.padding),
                      child: Stack(
                        children: [
                          Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: SizedBox(
                              width: double.infinity,
                              height: 80,
                              child: MaterialButton(
                                  child: Text("Continue"),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: advance
                              ),
                            ),
                          ),
                          Center(
                            child: Text("Crypto currency information app with current and historic crypto information."),
                      )
                    ],
                  ),
                )
              ),
            ],
          ),
        );
      }
    );
  }

}