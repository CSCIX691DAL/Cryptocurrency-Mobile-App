import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/Add%20Class/find_class_screen.dart';
import 'package:dal_app/models/DalCourseInfo.dart';
import 'package:dal_app/models/DalUser.dart';
import 'package:dal_app/models/DalUserTerm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dal_app/Main%20Interface/course_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  DalUserTerm term;
  DalUser userData;
  @override
  HomeScreen({this.term, this.userData});
  State<StatefulWidget> createState() {
    return _HomeScreenState(term: term, userData: userData);
  }
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  DalUserTerm term;
  DalUser userData;

  _HomeScreenState({this.term, this.userData});

  @override
  bool get wantKeepAlive => true;

  //This function is used to get courses from Firebase.
  Future<List<String>> getCourses() async {
    //This line gets every document in the collection, without any filtering.
    //The collection, named 'courses' in the database, contains documents, each of which correspond to a course

    //Below it is an example of a query for only courses in the computer science department

    //This query is marked with await, which means the execution of the function
    // will not proceed until the query is finished.
    // QuerySnapshot snap = await FirebaseFirestore.instance.collection("courses")
    //     .get();

    QuerySnapshot snap = await FirebaseFirestore.instance.collection("courses")
        .where("subjectCode", isEqualTo: "CSCI")
        .get();

    // When the courses are downloaded, we get them in a format called a
    // QueryDocumentSnapshot, which is just the type of object that firebase returns
    // from a query. In this case, we don't care for anything in that object but
    // the course code, so we map the list of these QueryDocumentSnapshot objects
    // into a list of strings using .map. This will go through each object in the list,
    // and for each will take the course code field, and add it to a new list of strings.
    List<String> courseCodes = snap.docs.map((course) => (course.get("code") as String)).toList();
    return courseCodes;
  }

  Widget build(BuildContext context) {
   return FutureBuilder<List<String>>(
     future: getCourses(),
     builder: (context, courses) {
       if(courses.connectionState != ConnectionState.done) {
         return Center(child: CircularProgressIndicator());
       }
       if(courses.hasError) {
         return Icon(Icons.error_outline, size: 100,);
       }

       var date = new DateFormat.MMMMEEEEd();
       //A ListView.builder widget will take in a number of items, and for each
       //of them will build a new widget to insert into a list. I think Card
       //widgets look good, so for every item in courses, I'll make a card,
       //put a ListTile (a widget that gives you a list item, with options for
       // titles, subtitles, leading images, etc) in the card, and set the title of
       // the ListTile to the course name at the index of the list.
       return SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.all(18.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(date.format(DateTime.now()).toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.grey[700]),),
               Text("Welcome, ${userData.name}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
               SizedBox(height: 30,),
               Text("Your Courses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               StreamBuilder<QuerySnapshot>(
                 stream: term.coursesUpdated(),
                 builder: (context, snapshot) {
                   if(!snapshot.hasData) {
                     return Center(child: CircularProgressIndicator(),);
                   }
                   if(snapshot.data.docs.length == 0) {
                     return Padding(
                       padding: const EdgeInsets.only(top: 8.0),
                       child: Column(
                         children: [
                           Text("Looks like you don't have any courses. Add one to get started."),
                           SizedBox(height: 10,),
                           ElevatedButton(onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => FindClassScreen()))}, child: Text("Add Course"))
                         ],
                       ),
                     );
                   }
                   return ListView.builder(
                     shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),
                     itemCount: snapshot.data.docs.length,
                       itemBuilder: (context, index) {
                       var course = DalCourseInfo.fromMap(snapshot.data.docs[index].data());
                         return Card(
                           child: ListTile(
                             onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailScreen(courseCode: snapshot.data.docs[index].id,)))},
                             title: Text(course.name),
                             subtitle: Text(snapshot.data.docs[index].id),
                           ),
                         );
                       },
                   );
                 }
               )
             ],
           ),
         ),
       );
     },
   );
  }
}