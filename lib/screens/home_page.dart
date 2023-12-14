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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                    height: height*0.03,
                  ),
                  HomePageCalendar(),
                  SizedBox(
                    height: height*0.03,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daily check-in',
                      style: kBold22,
                    ),
                  ),
                  SizedBox(
                    height: height*0.01,
                  ),
                  Container(
                    height: height*0.33,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          DailyCheckinBox(
                            value: morningRoutineProvider.countProgress(),
                            maximum: morningRoutineProvider.morningRoutines.length,
                            text: 'Morning Routine',
                            emojiName: 'morning',
                            colorGradient1: Color(0xFFCC2B5E),
                            colorGradient2: Color(0xFF753A88),
                          ),
                          SizedBox(
                            width: width*0.05,
                          ),
                          DailyCheckinBox(
                            value: nightRoutineProvider.countProgress(),
                            maximum: nightRoutineProvider.nightRoutines.length,
                            text: 'Night Routine',
                            emojiName: 'bed',
                            colorGradient1: Color(0xFFFF5F6D),
                            colorGradient2: Color(0xFFFFC371),
                          ),
                          SizedBox(
                            width: width*0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   height: height*0.33,
                  //   child: ListView.separated(
                  //     separatorBuilder: (context, index) {
                  //       return SizedBox(width: width*0.05);
                  //     },
                  //     itemCount: 3,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index){
                  //       return DailyCheckinBox();
                  //     },
                  //   ),
                  // ),
                  // ZROBIC SHOW BUTTONS? DEFAULT FALSE I WTEDY BEDZIE MOZNA ZROBIC TEZ LICZNIKI
                  SizedBox(
                    height: height*0.01,
                  ),
                  MorningRoutine(),
                  SizedBox(
                    height: height*0.03,
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
