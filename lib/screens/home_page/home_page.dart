import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:outwork/providers/daily_checkin_provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/navbar_controller_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/services/admob_service.dart';
import 'package:outwork/screens/home_page/pop_ups/add_daily_checkin_popup.dart';
import 'package:outwork/widgets/morning_routine.dart';
import 'package:outwork/widgets/daily_checkin_box.dart';
import 'package:outwork/widgets/home_page_calendar.dart';
import 'package:outwork/widgets/night_routine.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InterstitialAd? _fullScreenAd;
  @override
  void initState() {
    super.initState();
    _createFullScreenAD();
  }

  void _createFullScreenAD() {
    InterstitialAd.load(
      adUnitId: AdMobService.fullScreenAdUnitID!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _fullScreenAd = ad,
        onAdFailedToLoad: (LoadAdError error) {
          print(error);
      _fullScreenAd = null;
      }
      ),
    );
  }

  void _showFullScreenAd(){
    if (_fullScreenAd != null){
      _fullScreenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){
          ad.dispose();
          _createFullScreenAD();
        },
        onAdFailedToShowFullScreenContent: (ad, error){
          ad.dispose();
          _createFullScreenAD();
      },
      );
      _fullScreenAd!.show();
      _fullScreenAd = null;
    }
  }

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

    return Scaffold(
      appBar: const MainAppBar(),
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      NavbarControllerProvider navbarControllerProvider =
                          Provider.of<NavbarControllerProvider>(context,
                              listen: false);
                      navbarControllerProvider.jumpToTab(3);
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
              const HomePageCalendar(),
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
                    padding: const EdgeInsets.all(10),
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
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      _showFullScreenAd();
                      // showModalBottomSheet(
                      //   context: context,
                      //   isScrollControlled: true,
                      //   useRootNavigator: true,
                      //   builder: (context) => SingleChildScrollView(
                      //     child: Container(
                      //       // height: height*0.1,
                      //       padding: EdgeInsets.only(
                      //           bottom:
                      //               MediaQuery.of(context).viewInsets.bottom),
                      //       child: AddDailyCheckinPopup(
                      //         buttonText: 'Add',
                      //       ),
                      //     ),
                      //   ),
                      // );
                    },
                    child: const Icon(
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
              const MorningRoutine(),
              SizedBox(
                height: height * 0.02,
              ),
              const NightRoutine(),
            ],
          ),
        ),
      ),
    );
  }
}
