import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends StatelessWidget {

  String courseCode;
  CourseDetailScreen({this.courseCode});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(courseCode),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('courses').where('code', isEqualTo: courseCode).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data.docs.map((document) {

                return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
                        margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Text(
                          document['code'] + ': ' + document['name'],
                          style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
                        margin: EdgeInsets.fromLTRB(0, 20, 55, 0),
                        child: InkWell(
                          // onTap: () => launch('https://www.dal.ca/faculty/computerscience.html'),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'FACULTY OF COMPUTER SCIENCE',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'CREDIT HOURS: ' + document['creditHours'].toString(),
                            style: TextStyle(
                                fontSize: 17.0
                            ),
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            document['description'],
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                height: 1.3
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(100.0),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle
                        ),
                        // child: Align(
                        //   alignment: Alignment.centerLeft,
                        // ),
                      )
                    ]
                );
              }).toList(),
            );
          }
      ),
    );


    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('CSCI 2691'),
    //   ),
    //   body: Column(
    //     children: [
    //       Container(
    //         padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
    //         margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
    //         child: Text(
    //             'CSCI 2691: INTRODUCTORY PROJECT',
    //             style: TextStyle(
    //               fontSize: 28.0,
    //               fontWeight: FontWeight.bold
    //             ),
    //         ),
    //       ),
    //       Container(
    //         padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
    //         margin: EdgeInsets.fromLTRB(0, 20, 55, 0),
    //         child: InkWell(
    //           onTap: () => launch('https://www.dal.ca/faculty/computerscience.html'),
    //           child: Align(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               'FACULTY OF COMPUTER SCIENCE',
    //               style: TextStyle(
    //                   fontSize: 20.0,
    //                   fontWeight: FontWeight.bold
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
    //         margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
    //         child: Align(
    //           alignment: Alignment.centerLeft,
    //           child: Text(
    //             'CREDIT HOURS: 3',
    //             style: TextStyle(
    //                 fontSize: 17.0
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
    //         margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
    //         child: Align(
    //           alignment: Alignment.centerLeft,
    //           child: Text(
    //             'FORMAT: Lecture',
    //             style: TextStyle(
    //                 fontSize: 17.0
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
    //         margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
    //         child: Align(
    //           alignment: Alignment.centerLeft,
    //           child: Text(
    //             'PREREQUISITES: (CSCI 1170.03 or CSCI 1206.03 or '
    //                 'INFX 1606.03) and (CSCI 1100.03 or CSCI 1101.03 or '
    //                 'CSCI 1105.03 or CSCI 1110.03)',
    //             style: TextStyle(
    //                 fontSize: 17.0
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         padding: EdgeInsets.fromLTRB(13, 0, 5, 0),
    //         margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
    //         child: Align(
    //           alignment: Alignment.centerLeft,
    //           child: Text(
    //             'Students take junior roles in project teams to solve a '
    //                 'real-world information technology problem. Team '
    //                 'members are drawn from all years of study. The '
    //                 'project gives students an opportunity to develop their '
    //                 'technical, management, and professional skills. ',
    //             style: TextStyle(
    //                 fontSize: 18.0,
    //                 fontWeight: FontWeight.w500,
    //                 height: 1.3
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         margin: EdgeInsets.all(100.0),
    //         decoration: BoxDecoration(
    //             color: Colors.orange,
    //             shape: BoxShape.circle
    //         ),
    //         // child: Align(
    //         //   alignment: Alignment.centerLeft,
    //         // ),
    //       )
    //     ],
    //   ),
    // );
  }
}

