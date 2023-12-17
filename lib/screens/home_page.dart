import 'package:flutter/material.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/widgets/morning_routine.dart';
import 'package:outwork/widgets/daily_checkin_box.dart';
import 'package:outwork/widgets/home_page_calendar.dart';
import 'package:outwork/widgets/night_routine.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/text_styles.dart';
import 'package:outwork/providers/morning_routine_provider.dart';

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
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<UserProvider>(
            builder: (context, provider, child) {

              final morningRoutineProvider =
              Provider.of<MorningRoutineProvider>(context, listen: false);
              morningRoutineProvider.setMorningRoutines(provider.user!);
              final nightRoutineProvider =
              Provider.of<NightRoutineProvider>(context, listen: false);
              nightRoutineProvider.setNightRoutines(provider.user!);

              List<dynamic> dailyCheckins = provider.user!.dailyCheckins!;
              List<Widget> checkinBoxes = List.generate(dailyCheckins.length, (index) {
                print('colorxd');
                print(Color(dailyCheckins[index]['colors'][0]));
                List<Color> colors = [Color(dailyCheckins[index]['colors'][0]), Color(dailyCheckins[index]['colors'][1])];
                return Row(
                  children: [
                    DailyCheckinBox(maximum: dailyCheckins[index]['goal'],
                        value: dailyCheckins[index]['value'],
                        text: dailyCheckins[index]['name'],
                        unit: dailyCheckins[index]['unit'],
                        emojiName: dailyCheckins[index]['name'].toString().toLowerCase(),
                        step: dailyCheckins[index]['step'],
                        colorsGradient: colors,
                        hasButtons: true),
                    SizedBox(width: width*0.05,)
                  ],
                );
              });

              morningRoutineProvider.morningRoutines.length != 0? checkinBoxes.insert(0, Row(
                children: [
                  DailyCheckinBox(
                    value: morningRoutineProvider.countProgress(),
                    maximum: morningRoutineProvider.morningRoutines
                        .length,
                    unit: 'routines',
                    text: 'Morning Routine',
                    step: 1,
                    emojiName: 'morning',
                    colorsGradient: [Color(0xFFCC2B5E), Color(0xFF753A88)],
                    hasButtons: false,
                  ),
                  SizedBox(width: width*0.05,)
                ],
              )):null;

              nightRoutineProvider.nightRoutines.length != 0? checkinBoxes.insert(checkinBoxes.length, DailyCheckinBox(
                value: nightRoutineProvider.countProgress(),
                maximum: nightRoutineProvider.nightRoutines
                    .length,
                unit: 'routines',
                text: 'Night Routine',
                step: 1,
                emojiName: 'bed',
                colorsGradient: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
                hasButtons: false,
              )):null;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.05, horizontal: width * 0.07),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hello ${provider.user!.displayName}!',
                          style: kBold22,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'I believe in you.',
                          style: kHomePageGray,
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
                        child: Text(
                          'Daily check-in',
                          style: kBold22,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        height: height * 0.33,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: checkinBoxes
                          ),
                        ),
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
              );
            },
          )),
    );
  }
}
