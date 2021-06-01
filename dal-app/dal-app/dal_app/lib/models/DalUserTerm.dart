import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/models/DalTerm.dart';
import 'package:dal_app/models/DalUserCourse.dart';
import 'package:event_calendar/Calendar.dart';
import 'package:event_calendar/event_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DalUserTerm {
  DalTerm term;
  Calendar calendar = new Calendar();

  DalUserTerm({@required this.term});

  DayOfTheWeek getDayFromAbbr(String string) {
    switch(string.toLowerCase()) {
      case "mon":
        return DayOfTheWeek.Monday;
      case "tue":
        return DayOfTheWeek.Tuesday;
      case "wed":
        return DayOfTheWeek.Wednesday;
      case "thu":
        return DayOfTheWeek.Thursday;
      case "fri":
        return DayOfTheWeek.Friday;
      case "sat":
        return DayOfTheWeek.Saturday;
      case "sun":
        return DayOfTheWeek.Saturday;
    }
  }

  Stream<QuerySnapshot> coursesUpdated() {
    return FirebaseFirestore.instance
        .collection('terms')
        .doc(term.id)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('courses')
        .snapshots();
  }

  DalUserCalendar getCalendar(QuerySnapshot snap) {
    DalUserCalendar userCalendar = new DalUserCalendar();
    Calendar calendar = userCalendar.calendar;
    snap.docs.forEach((element) {
      print(element.data());
      String name = element.data()["name"];
      String courseCode = element.data()["courseCode"];
      Map<String, dynamic> timeMap = element.data()["time"];
      //start/end times represented in hh:mm format, so split by the ':'
      int startHourInt = int.parse(timeMap["startTime"].split(":")[0]);
      int startMinuteInt = int.parse(timeMap["startTime"].split(":")[1]);
      int endHourInt = int.parse(timeMap["endTime"].split(":")[0]);
      int endMinuteInt = int.parse(timeMap["endTime"].split(":")[1]);

      List<String> days = (timeMap['days'] as List)?.map((item) => item as String)?.toList();

      Event event = new Event(
          DateTime(
              term.startDate.year,
              term.startDate.month,
              term.startDate.day,
              startHourInt,
              startMinuteInt
          ),
          title: courseCode,
          description: name,
          endDate: DateTime(
              term.endDate.year,
              term.endDate.month,
              term.endDate.day,
              endHourInt,
              endMinuteInt
          ),
          recurrenceRule: RecurrenceRule(
              Frequency.weekly,
              byDay: days.map((e) => getDayFromAbbr(e)).toList(),
              until: term.endDate,
              count: -1
          )
      );
      calendar.addEvent(event);
    });
    return userCalendar;
  }
}