import 'dart:ffi';

import 'package:dal_app/Add%20Class/add_course_dates.dart';
import 'package:dal_app/models/DalUserCourse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(AddCourseDateScreen());
}


class AddCourseDateScreen extends StatefulWidget{

  void Function(List<String>, TimeOfDay, TimeOfDay) callback;

  AddCourseDateScreen({this.callback});

  @override
  State<StatefulWidget> createState() => _AddCourseDateScreenState(callback: this.callback);

}
class _AddCourseDateScreenState extends State<AddCourseDateScreen>{

  void Function(List<String>, TimeOfDay, TimeOfDay) callback;

  _AddCourseDateScreenState({this.callback});

  List<String> recurringClasses = [];
  String pickedTimeInString = "";

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  TimeOfDay picked;
  TimeOfDay endPicked;

  Future<Null> selectTime(BuildContext context) async{
    picked = await showTimePicker(
      context: context,
      initialTime: _time, );
    setState((){
     _time = picked;
      print(_time);
      pickedTimeInString = picked.toString();
    });
  }

  Future<Null> selectEndTime(BuildContext context) async{
    endPicked = await showTimePicker(
      context: context,
      initialTime: _time, );
    setState((){
      _endTime = endPicked;
      print(_time);
      pickedTimeInString = endPicked.toString();
    });
  }

  addClass(){
    Map<String,dynamic> demoData = {"class" : textEditor.text, "time" : pickedTimeInString, "recurring" : recurringClasses};
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('test');
    collectionReference.add(demoData);
    print(recurringClasses.toString());
  }

  Map data;
  addData(){
    Map<String,dynamic> demoData = {"class" : textEditor.text, "time" : "8:30"};
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('test');
    collectionReference.add(demoData);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditor = new TextEditingController();
  TextEditingController textEditor2 = new TextEditingController();
  TextEditingController textEditor3 = new TextEditingController();
  TextEditingController textEditor4 = new TextEditingController();

  bool monVal = false;
  bool tueVal = false;
  bool wedVal = false;
  bool thurVal = false;
  bool friVal = false;

  onDayChange() {
    List<String> list = [];

    if(monVal) {
      list.add("Mon");
    }
    if(tueVal) {
      list.add("Tue");
    }
    if(wedVal) {
      list.add("Wed");
    }
    if(thurVal) {
      list.add("Thu");
    }
    if(friVal) {
      list.add("Fri");
    }
    setState(() {
      recurringClasses = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Time'),
      ),
      body: Form(
        key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Class Time',
                    style: new TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        'Start Time:',
                      style: new TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      new IconButton(
                          icon: Icon(Icons.alarm),
                          onPressed:() {
                            selectTime(context);
                          }
                      ),
                      Text(_time.format(context))
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        'End Time:',
                        style: new TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      new IconButton(
                          icon: Icon(Icons.alarm),
                          onPressed:() {
                            selectEndTime(context);
                          }
                      ),
                      Text(_endTime.format(context))
                    ],
                  ),
                  Text(
                    'What days does this class take place on?',
                    style: new TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: new EdgeInsets.all(8.0),
                  ),
                  new Divider(height: 5.0, color: Colors.black),
                  new Padding(
                    padding: new EdgeInsets.all(8.0),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(value: monVal, onChanged: (newVal) {
                        setState(() {
                          monVal = newVal;
                        });
                        onDayChange();
                      }),
                      new Text(
                        'M',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Checkbox(value: tueVal, onChanged: (newVal) {
                        setState(() {
                          tueVal = newVal;
                        });
                        onDayChange();
                      }),
                      new Text(
                        'T',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Checkbox(value: wedVal, onChanged: (newVal) {
                        setState(() {
                          wedVal = newVal;
                        });
                        onDayChange();
                      }),
                      new Text(
                        'W',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Checkbox(value: thurVal, onChanged: (newVal) {
                        setState(() {
                          thurVal = newVal;
                        });
                        onDayChange();
                      }),
                      new Text(
                        'TR',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Checkbox(value: friVal, onChanged: (newVal) {
                        setState(() {
                          friVal = newVal;
                        });
                        onDayChange();
                      }),
                      new Text(
                        'F',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () {

                        callback(recurringClasses, _time, _endTime);

                        ScaffoldMessenger
                           .of(context)
                           .showSnackBar(SnackBar(content: Text('Saved!'), backgroundColor: Colors.green,));

                      },
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),

    );
  }


//testing firestore

}

/*import 'package:dal_app/add_course_dates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(AddAssignment());
}

Map data;
addData(){
  Map<String,dynamic> demoData = {"class" : "testFirestoreClass", "time" : "8:30"};
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('test');
  collectionReference.add(demoData);

}

class AddAssignment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //here I plan to make this button bring the user to another page where they can select/add some courses that they have, they will then update our database.
          addData();
        },
        child: Icon(Icons.add_circle_outline_sharp),
        backgroundColor: Colors.blue,
      ),

    );
  }


//testing firestore

}
 */