import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/FirebaseManager.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:dal_app/Add%20Class/add_course_dates.dart';
import 'package:dal_app/Add%20Class/find_class_subject_view.dart';
import 'package:dal_app/models/DalUserCourse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FindClassScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FindClassScreenState();
}

class _FindClassScreenState extends State<FindClassScreen> {

  List<DalUserCourse> coursesAdded = [];
  bool loading = false;
  @override

  void addCourse(DalUserCourse course) {
    setState(() {
      this.coursesAdded.add(course);
    });
  }

  Widget build(BuildContext context) {
    return loading ? FullScreenLoader() : Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          setState(() {
            loading = true;
          });
          await FirebaseManager().addCoursesToUser(coursesAdded);
          Navigator.pop(context);
        },
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        panelBuilder: (sc) {
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              controller: sc,
              children: [
                SizedBox(height: 10),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("${coursesAdded.length} Courses Added",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                  )
                ),
                SizedBox(height: 40,),
                Center(child: Text('Tap a course to set times for it')),
                ListView.builder(
                  itemCount: coursesAdded.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCourseDateScreen(
                              callback: (days, start, end){
                            setState(() {
                              coursesAdded[index].setTime(days, start, end);
                            });
                                print(coursesAdded);
                          })
                          ));
                        },
                        title: Text(coursesAdded[index].name),
                        subtitle: Text(coursesAdded[index].startTime != null ? "${coursesAdded[index].startTime.format(context)} - ${coursesAdded[index].endTime.format(context)}" : "No Time Set"),
                        trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: (){
                          setState(() {
                            coursesAdded.removeAt(index);
                          });
                        },),
                      ),
                    );
                  }
                )
              ]
            ),
          );
        },
        borderRadius: BorderRadius.circular(30),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('subjects').where("courseCount", isGreaterThanOrEqualTo: 1).orderBy("courseCount", descending: true).get(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return FullScreenLoader();
            }
            return SafeArea(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics()  ,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Course Finder", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                      ),),
                      SizedBox(height: 20,),
                      CupertinoSearchTextField(
                        placeholder: "Search Classes",
                      ),
                      SizedBox(height: 20,),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var list = snapshot.data.docs;
                          list.sort((a, b) => (a.get("name") as String).compareTo(b.get("name") as String));
                          return Card(
                              child: ListTile(
                                onTap: () => {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => FindClassSubjectView(callback: (course) => addCourse(course), courses: this.coursesAdded, subjectCode: list[index].id,)))
                                },
                                title: Text(list[index].get("name")),
                                subtitle: Text("${list[index].get("courseCount")} Courses"),
                              )
                          );
                        }
                      ),
                      SizedBox(height: 60,)
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

}