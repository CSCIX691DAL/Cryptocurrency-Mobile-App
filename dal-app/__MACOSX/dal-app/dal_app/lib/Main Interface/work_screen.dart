import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/FirebaseManager.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:dal_app/models/DalUserCourse.dart';
import 'package:dal_app/models/DalUserTerm.dart';
import 'package:dal_app/work_screen_info.dart';
import 'package:dal_app/models/DalWork.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkScreen extends StatelessWidget {

  DalUserTerm term;

  WorkScreen({this.term});
  @override
  Widget build(BuildContext context) {

    print(term.term.id);
    //current time
    var now = DateTime.now();

    var fb = FirebaseManager();

    return StreamBuilder<QuerySnapshot>(
      stream: term.coursesUpdated(),
      builder: (context, courseSnap) {
        if(!courseSnap.hasData) {
          return FullScreenLoader();
        }
        var courses = courseSnap.data.docs.map((e) => DalUserCourse(name: e.data()["name"], courseCode: e.data()["courseCode"])).toList();
        return StreamBuilder<List<DalWork>>(
          stream: fb.upcomingWorkStream(term.term),
          builder: (context, workSnap) {
            if(!workSnap.hasData) {return FullScreenLoader();}

            List<DalWork> getWorkForCourse(String course) {
              return workSnap.data.where((work) => work.courseCode == course).toList();
            }

            String getDueDateString(DateTime dueDate) {
              var difference = dueDate.difference(now);
              if(difference.inDays >= 7) {
                return "in ${(difference.inDays/7).round()} weeks";
              } else if(difference.inDays >= 1) {
                return "in ${difference.inDays} days";
              } else if(difference.inHours >= 1) {
                return "in ${difference.inHours} hours";
              } else if(difference.inMinutes >= 1) {
                return "in ${difference.inMinutes} minutes";
              } else {
                return 'Past Due :(';
              }
            }

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  //ensure space between different class groups
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //ensure data stretches across page
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Assignments",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        )
                    ),

                    //use Listview.builder to loop over cards+classes *****
                    Column(
                      children: [
                        //loop over num of classes
                        for(DalUserCourse course in courses)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:[
                              Padding(padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(course.name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              if(getWorkForCourse(course.courseCode).length > 0)
                                ListView.builder(
                                    itemCount: getWorkForCourse(course.courseCode).length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var workForCourse = getWorkForCourse(course.courseCode);
                                      print(workForCourse);
                                      return Card(
                                          color: Colors.grey[200],
                                          child: ListTile(
                                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WorkInfoScreen(work: workForCourse[index]))),
                                            title: Text(workForCourse[index].name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              getDueDateString(workForCourse[index].dueDate),
                                              style: TextStyle(
                                                //if there are 3 or less days before the due date, display text as red
                                                color: workForCourse[index].dueDate.difference(now).inDays < 3 ? Colors.red : Colors.black,
                                              ),
                                            ),
                                          )
                                      );
                                    }
                                )
                              else
                                Text("No upcoming assignments for ${course.courseCode}!")
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
