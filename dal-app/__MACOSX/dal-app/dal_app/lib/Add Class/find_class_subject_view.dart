import 'package:dal_app/FirebaseManager.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:dal_app/Main%20Interface/course_detail_screen.dart';
import 'package:dal_app/models/DalCourseInfo.dart';
import 'package:dal_app/models/DalUserCourse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FindClassSubjectView extends StatefulWidget {


  void Function(DalUserCourse) callback;
  String subjectCode;
  List<DalUserCourse> courses;
  FindClassSubjectView({this.callback, this.courses, this.subjectCode});

  @override
  State<StatefulWidget> createState() => _FindClassSubjectViewState(callback: this.callback, courses: this.courses, subjectCode: this.subjectCode);
}


class _FindClassSubjectViewState extends State<FindClassSubjectView> {

  void Function(DalUserCourse) callback;
  String subjectCode;
  List<DalUserCourse> courses;
  _FindClassSubjectViewState({this.callback, this.courses, this.subjectCode});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DalCourseInfo>>(
      future: FirebaseManager().getCoursesForSubject(subjectCode),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return FullScreenLoader();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Courses"),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: (() {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailScreen(courseCode: snapshot.data[index].code)));
                          }),
                          title: Text(snapshot.data[index].code),
                          subtitle: Text(snapshot.data[index].name),

                          leading: Checkbox(value: courses.where((element) => element.courseCode == snapshot.data[index].code).toList().length > 0, onChanged: (value) {
                            setState(() {
                              if(value) {
                                this.courses.add(DalUserCourse(name: snapshot.data[index].name, courseCode: snapshot.data[index].code));
                              } else {
                                this.courses.removeWhere((element) => element.courseCode == snapshot.data[index].code);
                              }
                            });
                          }),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        );
      }
    );
  }



}