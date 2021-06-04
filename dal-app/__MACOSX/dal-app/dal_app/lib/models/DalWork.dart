import 'package:flutter/cupertino.dart';

class DalWork {
  String name;
  String description;
  DateTime dueDate;
  String courseCode;

  DalWork({
      @required this.name,
      @required this.description,
      @required this.dueDate,
      @required this.courseCode
  });

  factory DalWork.fromMap(Map<String, dynamic> map) {
    return DalWork(name: map["name"],
        description: map["description"],
        dueDate: DateTime.fromMillisecondsSinceEpoch(map["dueDate"]),
        courseCode: map["courseCode"]
    );
  }
}