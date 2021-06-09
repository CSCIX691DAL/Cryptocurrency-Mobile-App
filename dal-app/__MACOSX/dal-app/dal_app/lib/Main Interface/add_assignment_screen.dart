import 'package:dal_app/FirebaseManager.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
// import 'package:material_dropdown_formfield/material_dropdown_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(AddAssignmentScreen());
}


class AddAssignmentScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AddAssignmentScreenState();


}
class AddAssignmentScreenState extends State<AddAssignmentScreen> {

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameTextController = new TextEditingController();
  TextEditingController descriptionTextController = new TextEditingController();
  String courseCode;
  bool loading = false;


  Future<Null> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365))
    );
    setState((){
      date = picked;
      print(date);
    });
  }
  Future<Null> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
        context: context,
        initialTime: time
    );
    setState((){
      time = picked;
    });
  }

  Future<void> createAssignment() async {
    setState(() {
      loading = true;
    });
    await FirebaseManager().addWork(nameTextController.text, courseCode, descriptionTextController.text, DateTime(date.year, date.month, date.day, time.hour, time.minute).millisecondsSinceEpoch);
    Navigator.pop(context);
  }

  String formatDate(DateTime date) {
    final format = DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY);
    return format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return loading ? FullScreenLoader() : Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Assignment'
        ),
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
                  "Assignment Name",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                TextFormField(
                  controller: nameTextController,
                  decoration: InputDecoration(
                      hintText: 'Assignment Name'
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'This field must not be empty';
                    }
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Course",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: FirebaseManager().getCourses(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return DropDownFormField(
                      titleText: null,
                      hintText: 'Please choose one',
                      value: courseCode,
                      onChanged: (value) {
                        setState(() {
                          courseCode = value;
                        });
                      },
                      dataSource: snapshot.data.map((e) => {'display': e['name'], 'value': e['courseCode']}).toList(),
                      textField: 'display',
                      valueField: 'value',
                    );
                  }
                ),
                SizedBox(height: 20),
                Text(
                  "Due Date",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 10,),
                          Text("Pick Date"),
                        ],
                      ),
                      onPressed: () {
                        selectDate(context);
                      },
                    ),
                    SizedBox(width: 10,),
                    Text(
                        formatDate(date)
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_rounded),
                          SizedBox(width: 10,),
                          Text("Pick Time"),
                        ],
                      ),
                      onPressed: () {
                        selectTime(context);
                      },
                    ),
                    SizedBox(width: 10,),
                    Text(
                        time.format(context)
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: descriptionTextController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.amber, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This field must not be empty';
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      createAssignment();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
