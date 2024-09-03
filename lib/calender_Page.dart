import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
class CalenderPage extends StatelessWidget {
  const CalenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: TableCalendar(
        
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
       
      //    calendarStyle: CalendarStyle(
         
       
      //  ),
      ),
    );
  }
}