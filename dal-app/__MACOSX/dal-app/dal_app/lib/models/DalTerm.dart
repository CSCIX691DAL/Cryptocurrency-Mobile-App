import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DalTerm {
  DateTime startDate;
  DateTime endDate;
  String name;
  String id;

  DalTerm({
    @required this.id,
    @required this.name,
    @required this.startDate,
    @required this.endDate
  });

  factory DalTerm.fromMap(Map<String, dynamic> map) {
    return DalTerm(
        id: map["id"],
        name: map["name"],
        startDate: DateTime.fromMillisecondsSinceEpoch(map["startDate"]),
        endDate: DateTime.fromMillisecondsSinceEpoch(map["startDate"])
    );
  }
}