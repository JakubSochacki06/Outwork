import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
class HomePageCalendar extends StatefulWidget {
  const HomePageCalendar({super.key});

  @override
  State<HomePageCalendar> createState() => _HomePageCalendarState();
}

class _HomePageCalendarState extends State<HomePageCalendar> {

  String weekDayToName(int weekDay){
    switch(weekDay){
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
    }
    return "invalid weekDay";
  }
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      // daysOfWeekStyle: DaysOfWeekStyle(
      //   decoration: BoxDecoration(color: Colors.red)
      // ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true
      ),
      // calendarBuilders: CalendarBuilders(
      //   defaultBuilder: (context, date, date2){
      //     return Container(
      //       color: Colors.grey,
      //       child: Center(child: Text(date.day.toString())),
      //     );
      //   },
      //   dowBuilder: (context, day){
      //     return Container(
      //       decoration: BoxDecoration(
      //         color: Colors.grey
      //       ),
      //       child: Center(
      //         child: Text(
      //             weekDayToName(day.weekday)
      //         ),
      //       ),
      //     );
      //   }
      // ),
      // headerVisible: false,
      weekNumbersVisible: true,
      firstDay: DateTime.now().subtract(Duration(days: 30)),
      lastDay: DateTime.now().add(Duration(days: 30)),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      calendarStyle: CalendarStyle(
        // defaultDecoration: BoxDecoration(
        //   color: Colors.red
        // )
      ),
    );
  }
}
