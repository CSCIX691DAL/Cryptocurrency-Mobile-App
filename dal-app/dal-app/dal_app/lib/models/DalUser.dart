import 'package:flutter/cupertino.dart';

class DalUser {
  String name;
  String email;
  bool isFirstAuth;

  DalUser({
    @required this.name,
    @required this.email,
    @required this.isFirstAuth
  });

  factory DalUser.fromMap(Map<String, dynamic> map) {
    return DalUser(name: map["name"], email: map["email"], isFirstAuth: map["firstAuth"]);
  }
}