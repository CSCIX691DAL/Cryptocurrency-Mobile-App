import 'package:flutter/cupertino.dart';

class DalCourseInfo {
  String name;
  String code;
  String description;
  String subjectCode;

  DalCourseInfo({
    @required this.name,
    @required this.code,
    @required this.description,
    @required this.subjectCode
  });

  factory DalCourseInfo.fromMap(Map<String, dynamic> map) {
    return DalCourseInfo(
        name: map["name"],
        code: map["code"],
        description: map["description"],
        subjectCode: map["subjectCode"]
    );
  }
}