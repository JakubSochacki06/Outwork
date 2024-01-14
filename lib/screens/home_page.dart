import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/daily_checkin_provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/widgets/morning_routine.dart';
import 'package:outwork/widgets/daily_checkin_box.dart';
import 'package:outwork/widgets/home_page_calendar.dart';
import 'package:outwork/widgets/night_routine.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/string_extension.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    MorningRoutineProvider morningRoutineProvider =
    Provider.of<MorningRoutineProvider>(context, listen: true);
    morningRoutineProvider.setMorningRoutines(userProvider.user!);
    NightRoutineProvider nightRoutineProvider =
    Provider.of<NightRoutineProvider>(context, listen: true);
    nightRoutineProvider.setNightRoutines(userProvider.user!);
    DailyCheckinProvider dailyCheckinProvider =
    Provider.of<DailyCheckinProvider>(context, listen: true);
    dailyCheckinProvider.setDailyCheckins(userProvider.user!);
    JournalEntryProvider journalEntryProvider =
    Provider.of<JournalEntryProvider>(context, listen: true);
    journalEntryProvider.setJournalEntries(userProvider.user!);

    List<dynamic> dailyCheckins = dailyCheckinProvider.dailyCheckins;
    List<Widget> checkinBoxes =
    List.generate(dailyCheckins.length, (index) {
      List<Color> colors = [
        HexColor(dailyCheckins[index]['colors'][0]),
        HexColor(dailyCheckins[index]['colors'][1])
      ];
      return Row(
        children: [
          DailyCheckinBox(
              text: dailyCheckins[index]['name'],
              unit: dailyCheckins[index]['unit'],
              emojiName:
              dailyCheckins[index]['name'].toString().toLowerCase(),
              step: dailyCheckins[index]['step'],
              colorsGradient: colors,
              index: index,
              hasButtons: true),
          SizedBox(
            width: width * 0.05,
          )
        ],
      );
    });

    checkinBoxes.insert(
        0,
        Row(
          children: [
            DailyCheckinBox(
              unit: 'routines',
              text: 'Morning',
              step: 1,
              index: 0,
              emojiName: 'morning',
              colorsGradient: [Color(0xFF78ffd6), Color(0xFFa8ff78)],
              hasButtons: false,
            ),
            SizedBox(
              width: width * 0.05,
            )
          ],
        ));

    checkinBoxes.insert(
        checkinBoxes.length,
        DailyCheckinBox(
          unit: 'routines',
          text: 'Night',
          index: -1,
          step: 1,
          emojiName: 'bed',
          colorsGradient: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
          hasButtons: false,
        ));

    return Scaffold(
      appBar: MainAppBar(),
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.04),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello ${userProvider.user!.displayName}!',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  textAlign: TextAlign.left,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'I believe in you.',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onPrimaryContainer),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              HomePageCalendar(),
              SizedBox(
                height: height * 0.03,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      'Daily check-in',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          '${dailyCheckinProvider.countDoneCheckins(
                              morningRoutineProvider
                                  .morningRoutineFinished(),
                              nightRoutineProvider
                                  .nightRoutineFinished())}/${dailyCheckinProvider
                              .dailyCheckins.length + 2}',
                          style: dailyCheckinProvider.countDoneCheckins(
                              morningRoutineProvider
                                  .morningRoutineFinished(),
                              nightRoutineProvider
                                  .nightRoutineFinished()) !=
                              dailyCheckinProvider
                                  .dailyCheckins.length +
                                  2
                              ? Theme
                              .of(context)
                              .primaryTextTheme
                              .labelLarge
                              : Theme
                              .of(context)
                              .primaryTextTheme
                              .labelLarge!
                              .copyWith(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {},
                      child: Icon(
                        Icons.add,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: checkinBoxes),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              MorningRoutine(),
              SizedBox(
                height: height * 0.03,
              ),
              NightRoutine(),
            ],
          ),
        ),
      ),);
  }
}
