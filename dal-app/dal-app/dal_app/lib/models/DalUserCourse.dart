import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_calendar/Calendar.dart';
import 'package:event_calendar/Event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:intl/intl.dart';

class DalUserCalendar {

  Calendar calendar = new Calendar();

  List<FlutterWeekViewEvent> getCoursesforDate(DateTime date) {
    var events = this.calendar.getEvents(date, date.add(Duration(hours: 23)));
    return events.map((e) {
      DateTime startDate = DateTime(date.year, date.month, date.day, e.startDate.hour, e.startDate.minute);
      DateTime endDate = DateTime(date.year, date.month, date.day, e.endDate.hour, e.endDate.minute);
      return FlutterWeekViewEvent(title: e.title, description: e.description, start: startDate, end: endDate);
    }).toList();
  }
}

class DalUserCourse {
  String courseCode;
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<String> days;

  DalUserCourse({@required this.name, @required this.courseCode, this.startTime, this.endTime});

  void setTime(List<String> days, TimeOfDay start, TimeOfDay end) {
    this.days = days;
    this.startTime = start;
    this.endTime = end;
  }

  Map toMap() {
    Map<String, dynamic> map = new Map();

    map["name"] = name;
    map["courseCode"] = courseCode;

    Map<String, dynamic> timeMap = new Map();

    final now = new DateTime.now();
    final startTimeFormatted = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endTimeFormatted = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    final format = DateFormat(DateFormat.HOUR24_MINUTE);

    timeMap["days"] = days;
    timeMap["startTime"] = format.format(startTimeFormatted);
    timeMap["endTime"] = format.format(endTimeFormatted);

    map["time"] = timeMap;

    return map;
  }

  @override
  String toString() {
    return "${courseCode}";
  }
}