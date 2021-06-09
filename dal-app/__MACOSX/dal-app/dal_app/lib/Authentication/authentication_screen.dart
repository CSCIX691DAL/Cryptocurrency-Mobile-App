import 'package:dal_app/Authentication/Sign%20Up/sign_up_screen.dart';
import 'package:dal_app/Authentication/landing_screen.dart';
import 'package:dal_app/Authentication/sign_in_screen.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthenticationScreenState();
}
class _AuthenticationScreenState extends State<AuthenticationScreen> with SingleTickerProviderStateMixin {
  @override
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          LandingScreen(advance: (){_tabController.animateTo(1);}),
          SignInScreen(createAccount: (){_tabController.animateTo(2);}),
          SignUpScreen(back: (){_tabController.animateTo(1);})
        ],
      ),
    );
  }
}