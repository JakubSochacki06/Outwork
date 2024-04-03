import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePageCalendar extends StatefulWidget {
  const HomePageCalendar({super.key});

  @override
  State<HomePageCalendar> createState() => _HomePageCalendarState();
}

class _HomePageCalendarState extends State<HomePageCalendar> {
  String weekDayToName(int weekDay) {
    switch (weekDay) {
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context);
    ThemeProvider themeProvider =
    Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: themeProvider.isLightTheme()?Border.all(color: const Color(0xFFEDEDED)):null,
        // // color: Color(0xFFF0F2F5),

        boxShadow: themeProvider.isLightTheme()?[
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            // offset: Offset(3, 3),
          )
        ]:null,
      ),
      child: TableCalendar(
        // daysOfWeekStyle: DaysOfWeekStyle(
        //   decoration: BoxDecoration(color: Colors.red)
        // ),
        // headerVisible: false,
        headerStyle:
            const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, date, date2) {
            if (journalEntryProvider.journalEntries.any((element) =>
                element.date!.day == date.day &&
                element.date!.month == date.month &&
                element.date!.year == date.year)) {
              String feelingEmote = journalEntryProvider.journalEntries
                  .lastWhere((element) =>
                      element.date!.day == date.day &&
                      element.date!.month == date.month &&
                      element.date!.year == date.year)
                  .feeling!;
              return Container(
                child: Center(
                  child: Image.asset(
                    'assets/emojis/$feelingEmote.png',
                    height: height * 0.06,
                    width: width * 0.08,
                  ),
                ),
              );
            } else {
              return Container(
                height: height * 0.06,
                width: width * 0.1,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12,
                ),
                child: Center(child: Text(date.day.toString(), style: Theme.of(context).textTheme.labelLarge)),
              );
            }
          },
          defaultBuilder: (context, date, date2) {
            if (journalEntryProvider.journalEntries.any((element) =>
                element.date!.day == date.day &&
                element.date!.month == date.month &&
                element.date!.year == date.year)) {
              String feelingEmote = journalEntryProvider.journalEntries
                  .lastWhere((element) =>
                      element.date!.day == date.day &&
                      element.date!.month == date.month &&
                      element.date!.year == date.year)
                  .feeling!;
              return Container(
                child: Center(
                  child: Image.asset(
                    'assets/emojis/$feelingEmote.png',
                    height: height * 0.06,
                    width: width * 0.08,
                  ),
                ),
              );
            } else {
              return Container(
                // color: Colors.grey,
                child: Center(child: Text(date.day.toString(), style: Theme.of(context).primaryTextTheme.bodyMedium)),
              );
            }
          },
          dowBuilder: (context, date){
            bool isToday = date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year;
            return Center(
                child: Text(
                    weekDayToName(date.weekday),
                  style: isToday?Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.secondary):Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)!,
                ),
              );
          }
        ),
        // headerVisible: false,
        // weekNumbersVisible: true,
        firstDay: DateTime.now().subtract(const Duration(days: 30)),
        lastDay: DateTime.now().add(const Duration(days: 30)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        calendarStyle: const CalendarStyle(
            // defaultDecoration: BoxDecoration(
            //   color: Colors.red
            // )
            ),
      ),
    );
  }
}
