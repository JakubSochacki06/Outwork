import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/string_extension.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageCalendar extends StatefulWidget {
  const HomePageCalendar({super.key});

  @override
  State<HomePageCalendar> createState() => _HomePageCalendarState();
}

class _HomePageCalendarState extends State<HomePageCalendar> {
  String weekDayToName(int weekDay) {
    switch (weekDay) {
      case 1:
        return AppLocalizations.of(context)!.weekday1;
      case 2:
        return AppLocalizations.of(context)!.weekday2;
      case 3:
        return AppLocalizations.of(context)!.weekday3;
      case 4:
        return AppLocalizations.of(context)!.weekday4;
      case 5:
        return AppLocalizations.of(context)!.weekday5;
      case 6:
        return AppLocalizations.of(context)!.weekday6;
      case 7:
        return AppLocalizations.of(context)!.weekday7;
    }
    return AppLocalizations.of(context)!.invalidWeekDay;
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
        HeaderStyle(formatButtonVisible: false, titleCentered: true, titleTextFormatter: (date, locale){
              return DateFormat('yMMMM', themeProvider.selectedLocale!.languageCode).format(date).toString().capitalize();
            }),
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
