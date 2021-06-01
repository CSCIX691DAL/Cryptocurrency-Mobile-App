
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/models/DalCourseInfo.dart';
import 'package:dal_app/models/DalUser.dart';
import 'package:dal_app/models/DalUserCourse.dart';
import 'package:dal_app/models/DalWork.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/DalTerm.dart';

class FirebaseManager {

  Future<DalTerm> getCurrentTerm() async {
    int current = DateTime.now().millisecondsSinceEpoch;
    QuerySnapshot snap = await FirebaseFirestore.instance.collection("terms")
        .where("startDate", isLessThanOrEqualTo: current)
        .get();
    Map<String, dynamic> map = snap.docs.singleWhere((element) => element.data()["endDate"] > current).data();
    return DalTerm.fromMap(map);
  }

  Stream<List<DalWork>> upcomingWorkStream(DalTerm term) {
    return FirebaseFirestore.instance
        .collection("terms")
        .doc(term.id)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('work')
        .where('dueDate', isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
        .snapshots().map((event) => event.docs.map((e) => DalWork.fromMap(e.data())).toList());
  }

  Stream<List<DalWork>> pastWorkStream(DalTerm term) {
    return FirebaseFirestore.instance
        .collection("terms")
        .doc(term.id)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('work')
        .where('dueDate', isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
        .snapshots().map((event) => event.docs.map((e) => DalWork.fromMap(e.data())).toList());
  }

  Future<List<Map<String, dynamic>>> getCourses() async {
    var term = await getCurrentTerm();
    var courses = await FirebaseFirestore.instance
        .collection("terms")
        .doc(term.id)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('courses')
        .get();
    courses.docs.where((element) => element.data()["courseCode"] == "CSCI2134").toList();
    return courses.docs.map((e) => e.data()).toList();
  }
  
  Future<List<DalCourseInfo>> getCoursesForSubject(String subject) async {
    var courses = await FirebaseFirestore.instance
        .collection('courses')
        .where('subjectCode', isEqualTo: subject)
        .get();
    return courses.docs.map((e) => DalCourseInfo.fromMap(e.data())).toList();
  }

  Future<void> addCoursesToUser(List<DalUserCourse> courses) async {
    var term = await getCurrentTerm();
    courses.forEach((course) async {
      await FirebaseFirestore.instance
          .collection("terms")
          .doc(term.id)
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('courses')
          .doc(course.courseCode)
          .set(course.toMap());
    });
    return true;
  }

  Future<void> addWork(String name, String courseCode, String description, int dueDate) async {
    var term = await getCurrentTerm();
    return FirebaseFirestore.instance
        .collection("terms")
        .doc(term.id)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('work')
        .add({
          'name': name,
          'courseCode': courseCode,
          'description': description,
          'dueDate': dueDate
        });
  }

}