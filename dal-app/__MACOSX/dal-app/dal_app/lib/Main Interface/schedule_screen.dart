import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:dal_app/Add%20Class/add_course_dates.dart';
import 'package:dal_app/models/DalTerm.dart';
import 'package:dal_app/models/DalUserCourse.dart';
import 'package:dal_app/models/DalUserTerm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({this.term});

  final DalUserTerm term;

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState(term: term);
}

class _ScheduleScreenState extends State<ScheduleScreen> with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  CalendarController _calendarController = new CalendarController();
  DalUserTerm term;

  _ScheduleScreenState({this.term});

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List holidays, List events) {
    setState(() {
      _selectedDate = DateTime(day.year, day.month, day.day, 0, 0);
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    //UNUSED
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    //UNUSED
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildEventList(),
        Container(
          color: Colors.white,
            child: _buildTableCalendar()
        )
      ],
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.amber,
        todayColor: Colors.amber[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
        TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      initialCalendarFormat: CalendarFormat.week,
      availableCalendarFormats: {CalendarFormat.week:""},
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      // onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return StreamBuilder<Object>(
      stream: this.term.coursesUpdated(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return FullScreenLoader();
        }
        var events = this.term.getCalendar(snapshot.data).getCoursesforDate(_selectedDate);
        return DayView(
          date: _selectedDate,
          inScrollableWidget: true,
          userZoomable: false,
          minimumTime: HourMinute(hour: 1),
          initialTime: HourMinute(hour: HourMinute.now().hour-2),
          events: events,
          hoursColumnTimeBuilder: (context, hour) {
            TimeOfDay time = TimeOfDay(hour: hour.hour, minute: hour.minute);
            String suffix;
            if(time.period == DayPeriod.am) {
              suffix = "AM";
            } else {
              suffix = "PM";
            }
            if(hour.hour == 12) {
              return Text("12 PM");
            }
            return Text("${time.hour - time.periodOffset} ${suffix}");
          },
          style: DayViewStyle(
            headerSize: 30,
            hourRowHeight: 100
          ),
        );
      }
    );

  }
}
