import 'package:dal_app/models/DalWork.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkInfoScreen extends StatefulWidget {
  @override
  DalWork work;
  WorkInfoScreen({@required this.work});
  State<StatefulWidget> createState() =>_WorkInfoScreenState(work: work);
}

class _WorkInfoScreenState extends State<WorkInfoScreen>{


  DalWork work;

  //current time
  var now = DateTime.now();
  var boxChecked=false;


  //set variables with constructor
  _WorkInfoScreenState({
    @required this.work
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(work.name,
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(work.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('${work.description}',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
              //**** TRAILING CODE ******
                '${work.dueDate.difference(now).inDays} days until due date'
          ),
        ),
              Row(
                children: [
                  Checkbox(
                    value: boxChecked,
                    onChanged: (bool newValue) {
                      setState(() {
                        boxChecked = newValue;
                      });
                    },
                      ),
                  Text("Completed?",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}