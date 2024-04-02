import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/daily_checkin_provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/navbar_controller_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/screens/chat_page.dart';
import 'package:outwork/screens/home_page/pop_ups/add_daily_checkin_popup.dart';
import 'package:outwork/services/notifications_service.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    MorningRoutineProvider morningRoutineProvider =
        Provider.of<MorningRoutineProvider>(context, listen: true);
    NightRoutineProvider nightRoutineProvider =
        Provider.of<NightRoutineProvider>(context, listen: true);
    DailyCheckinProvider dailyCheckinProvider =
        Provider.of<DailyCheckinProvider>(context, listen: true);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    dailyCheckinProvider.setDailyCheckins(userProvider.user!);
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context, listen: true);
    journalEntryProvider.setJournalEntries(userProvider.user!);
    List<Widget> checkinBoxes =
        List.generate(dailyCheckinProvider.dailyCheckins.length, (index) {
      return Row(
        children: [
          DailyCheckinBox(
            index: index,
          ),
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
              routineName: 'Morning',
              index: 0,
            ),
            SizedBox(
              width: width * 0.05,
            )
          ],
        ));

    checkinBoxes.insert(
        checkinBoxes.length,
        DailyCheckinBox(
          routineName: 'Night',
          index: -1,
        ));
    print(LocalNotifications.showOngoingNotifications());
    userProvider.user!.dailyCheckins!.forEach((element) {print(element.toMap());});
    return Scaffold(
      appBar: MainAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ${userProvider.user!.displayName}!',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'I believe in you.',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      NavbarControllerProvider navbarControllerProvider = Provider.of<NavbarControllerProvider>(context, listen: false);
                      navbarControllerProvider.jumpToTab(4);
                    },
                    child: CircleAvatar(
                      radius: 35,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.network(userProvider.user!.photoURL!)),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              HomePageCalendar(),
              // SizedBox(
              //   height: height * 0.02,
              // ),
              // Row(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(5),
              //       decoration: BoxDecoration(
              //         color: Theme.of(context).colorScheme.primary,
              //         border: themeProvider.isLightTheme()
              //             ? Border.all(color: Color(0xFFEDEDED))
              //             : null,
              //         // color: Color(0xFFF0F2F5),
              //         borderRadius:
              //         BorderRadius.all(Radius.circular(15)),
              //         boxShadow: themeProvider.isLightTheme()
              //             ? [
              //           BoxShadow(
              //             color: Colors.grey.withOpacity(0.3),
              //             spreadRadius: 2,
              //             blurRadius: 3,
              //             // blurRadius: 10,
              //             offset: Offset(3, 3),
              //           )
              //         ]
              //             : null,
              //       ),
              //       child: Text('Mood tracker', style: Theme.of(context).primaryTextTheme.labelLarge,),
              //     ),
              //     Spacer(),
              //     Text(
              //         'How are you feeling?',
              //         style: Theme
              //             .of(context)
              //             .textTheme
              //             .bodyLarge
              //     ),
              //   ],
              // ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                children: [
                  Text(
                    'Daily check-in',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        '${dailyCheckinProvider.countDoneCheckins(morningRoutineProvider.morningRoutineFinished(), nightRoutineProvider.nightRoutineFinished())}/${dailyCheckinProvider.dailyCheckins.length + 2}',
                        style: dailyCheckinProvider.countDoneCheckins(
                                    morningRoutineProvider
                                        .morningRoutineFinished(),
                                    nightRoutineProvider
                                        .nightRoutineFinished()) !=
                                dailyCheckinProvider.dailyCheckins.length + 2
                            ? Theme.of(context).primaryTextTheme.labelLarge
                            : Theme.of(context)
                                .primaryTextTheme
                                .labelLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            // height: height*0.1,
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddDailyCheckinPopup(
                              buttonText: 'Add',
                            ),
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add,
                      size: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: checkinBoxes),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              MorningRoutine(),
              SizedBox(
                height: height * 0.02,
              ),
              NightRoutine(),
            ],
          ),
        ),
      ),
    );
  }
}
