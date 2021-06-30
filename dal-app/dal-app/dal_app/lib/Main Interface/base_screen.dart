import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:dal_app/Add%20Class/add_course_dates.dart';
import 'package:dal_app/Main%20Interface/add_assignment_screen.dart';
import 'package:dal_app/Add%20Class/find_class_screen.dart';
import 'package:dal_app/models/DalTerm.dart';
import 'package:dal_app/models/DalUser.dart';
import 'package:dal_app/models/DalUserCourse.dart';
import 'package:dal_app/models/DalUserTerm.dart';
import 'package:dal_app/Main%20Interface/schedule_screen.dart';
import 'package:dal_app/Main%20Interface/work_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';


class BaseScreen extends StatelessWidget {

  Future<DalTerm> getCurrentTerm() async {
    int current = DateTime.now().millisecondsSinceEpoch;
    QuerySnapshot snap = await FirebaseFirestore.instance.collection("terms")
        .where("startDate", isLessThanOrEqualTo: current)
        .get();
    Map<String, dynamic> map = snap.docs.singleWhere((element) => element.data()["endDate"] > current).data();
    return DalTerm.fromMap(map);
  }

  Future<DalUser> getUser() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get();
    DalUser user = DalUser.fromMap(doc.data());
    return user;
  }

  Future<Map<String, dynamic>> getData() async {
    var user = await getUser();
    var term = await getCurrentTerm();
    var map = {"user":user, "term":term};
    return map;
  }

  @override
  Widget build(BuildContext context) {
    // return FindClassScreen();
    return FutureBuilder<Map<String, dynamic>>(
      future: getData(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Scaffold(body: FullScreenLoader(),);
        }
        var userTerm = DalUserTerm(term: snapshot.data["term"]);

        return DefaultTabController(
          initialIndex: 1,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              // Here we set the title of the app bar, which in our case is set
              // to the Dalhousie logo. We wrap the image with a SizedBox widget,
              // in order to force it's height to be 60, which looks good in the
              // app bar.
              title: SizedBox(
                child: Image.asset("assets/logo.png"),
                height: 60,
              ),
              actions: [
                IconButton(icon: Icon(Icons.logout), onPressed: () => FirebaseAuth.instance.signOut())
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: TabBar(
                tabs: [
                  Tab(
                    text: "Schedule",
                    icon: Icon(Icons.calendar_today),
                  ),
                  Tab(
                    text: "Home",
                    icon: Icon(Icons.home),
                  ),
                  Tab(
                    text: "Work",
                    icon: Icon(Icons.assignment),
                  )
                ],
              ),
            ),
            //A TabBarView simply holds a list of all the views to correspond
            //with the tabs in the TabBar. The DefaultTabController will match
            //them up for us
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                  ScheduleScreen(term: userTerm),
                  HomeScreen(term: userTerm, userData: snapshot.data["user"]),
                  WorkScreen(term: userTerm)
              ]
            ),
            floatingActionButton: FloatingActionButton(
              child: PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.assignment),
                        SizedBox(width: 10),
                        Text("Assignment")
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.school),
                        SizedBox(width: 10),
                        Text("Class")
                      ],
                    ),
                  ),
                ],
                icon: Icon(Icons.library_add),
                offset: Offset(0, -150),
                onSelected: (value) {
                  if(value == 2) { //for add class
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindClassScreen()),
                    );
                  }
                  if(value == 1) { //for add assignment
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAssignmentScreen()),
                    );
                  }
                },
              ),
              backgroundColor: Colors.blue,
            ),
          )
        );
      }
    );
  }
}