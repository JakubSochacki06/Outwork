import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/chat_page.dart';
import 'package:outwork/widgets/appBars/bad_habits_app_bar.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';
import 'package:outwork/widgets/soberity_timer.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BadHabitsPage extends StatefulWidget {
  const BadHabitsPage({super.key});

  @override
  State<BadHabitsPage> createState() => _BadHabitsPageState();
}

class _BadHabitsPageState extends State<BadHabitsPage> {
  int currentIndex = 0;

  String getEnglishHabitName(String habitName) {
    // Create an instance of AppLocalizations
    final localizations = AppLocalizations.of(context);

    // Map localized habit names to English habit names
    final Map<String, String> habitNamesMap = {
      localizations!.junkFood: "Junk food",
      localizations.pornography: "Pornography",
      localizations.gambling: "Gambling",
      localizations.gaming: "Gaming",
      localizations.alcohol: "Alcohol",
      localizations.overspending: "Overspending",
      localizations.partying: "Partying",
      localizations.drugs: "Drugs",
      localizations.smoking: "Smoking",
      localizations.socialMedia: "Social media",
      localizations.swearing: "swearing",
    };

    // Return the English habit name if found, else return the original habit name
    return habitNamesMap[habitName] ?? habitName;
  }

  String getLocalizedHabitName(String englishHabitName) {
    // Create an instance of AppLocalizations
    final localizations = AppLocalizations.of(context);

    // Map English habit names to localized habit names
    final Map<String, String> habitNamesMap = {
      "Junk food": localizations!.junkFood,
      "Pornography": localizations.pornography,
      "Gambling": localizations.gambling,
      "Gaming": localizations.gaming,
      "Alcohol": localizations.alcohol,
      "Overspending": localizations.overspending,
      "Partying": localizations.partying,
      "Drugs": localizations.drugs,
      "Smoking": localizations.smoking,
      "Social media": localizations.socialMedia,
      "Swearing": localizations.swearing,
    };

    // Return the localized habit name if found, else return the original English habit name
    return habitNamesMap[englishHabitName] ?? englishHabitName;
  }

  Future<bool?> wantToRestartHabit(BuildContext context) async {
    bool? restartHabit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.restartTimer,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          content: Text(
              AppLocalizations.of(context)!.restartTimerConfirm,
              style: Theme.of(context).primaryTextTheme.bodySmall),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.no,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.yes, style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        );
      },
    );
    return restartHabit;
  }

  @override
  void dispose() {
    currentIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    DateTime? selectedStartDate;
    List<dynamic>? keys;
    if (progressProvider.badHabits.length != 0) {
      keys = progressProvider.badHabits.keys.toList();
      selectedStartDate = progressProvider
                  .badHabits[keys[currentIndex]]['startDate'].runtimeType !=
              DateTime
          ? progressProvider.badHabits[keys[currentIndex]]['startDate'].toDate()
          : progressProvider.badHabits[keys[currentIndex]]['startDate'];
    }
    return Scaffold(
      appBar: BadHabitsAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.04),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.01),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.asset('assets/images/jacob.png')),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.wantToTalkAboutIt,
                                style: Theme.of(context).textTheme.bodyLarge),
                            Text(
                              AppLocalizations.of(context)!.noMatterWhat,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              progressProvider.badHabits.length != 0
                  ? Column(
                      children: [
                        Container(
                          height: height * 0.3,
                          child: CarouselSlider.builder(
                            itemCount: progressProvider.badHabits.length,
                            itemBuilder: (context, index, pageViewIndex) {
                              return Image.asset(
                                  'assets/bad habits/${getEnglishHabitName(keys![index]).toLowerCase()}.png');
                            },
                            options: CarouselOptions(
                              height: height * 0.4,
                              viewportFraction: 0.66,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        AnimatedSmoothIndicator(
                          activeIndex: currentIndex,
                          count: keys!.length,
                          effect: SlideEffect(
                              dotColor: Theme.of(context).colorScheme.primary,
                              activeDotColor:
                                  Theme.of(context).colorScheme.secondary),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Row(
                          children: [
                            Text(
                              '${getLocalizedHabitName(keys[currentIndex])} ${AppLocalizations.of(context)!.freeFor}',
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 1,
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () async {
                                bool? wantToRestart =
                                    await wantToRestartHabit(context);
                                if (wantToRestart == true) {
                                  progressProvider.restartBadHabit(
                                      keys![currentIndex],
                                      userProvider.user!.email!);
                                }
                              },
                              child: Icon(Icons.restart_alt),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.selectDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                      content: StatefulBuilder(
                                          builder: (context, setState) {
                                        return Container(
                                          height: height * 0.4,
                                          width: width * 0.8,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: height * 0.33,
                                                width: width * 0.8,
                                                child: SfDateRangePicker(
                                                  initialSelectedDate:
                                                      selectedStartDate,
                                                  initialDisplayDate:
                                                      selectedStartDate,
                                                  todayHighlightColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  selectableDayPredicate:
                                                      (DateTime dateTime) {
                                                    if (dateTime.isAfter(
                                                        DateTime.now())) {
                                                      return false;
                                                    }
                                                    return true;
                                                  },
                                                  onCancel: () {
                                                    Navigator.pop(context);
                                                  },
                                                  selectionColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  onSelectionChanged: (arg) {
                                                    setState(() {
                                                      selectedStartDate =
                                                          arg.value;
                                                    });
                                                  },
                                                  // selectionShape: DateRangePickerSelectionShape.rectangle,
                                                  showNavigationArrow: true,
                                                  monthViewSettings:
                                                      const DateRangePickerMonthViewSettings(
                                                          firstDayOfWeek: 1),
                                                  // onSelectionChanged: ,
                                                  selectionMode:
                                                      DateRangePickerSelectionMode
                                                          .single,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        AppLocalizations.of(context)!.cancel,
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .labelLarge,
                                                      )),
                                                  TextButton(
                                                      onPressed:
                                                          selectedStartDate !=
                                                                  null
                                                              ? () async {
                                                                  await progressProvider.changeBadHabitStart(
                                                                      keys![
                                                                          currentIndex],
                                                                      userProvider
                                                                          .user!
                                                                          .email!,
                                                                      selectedStartDate!);
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              : null,
                                                      child: Text(
                                                        AppLocalizations.of(context)!.submit,
                                                        style: selectedStartDate !=
                                                                null
                                                            ? Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge!
                                                                .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .secondary)
                                                            : Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge!
                                                                .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimaryContainer),
                                                      ),),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              child: Icon(Icons.settings),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        SobrietyTimer(
                            sobrietyDate: progressProvider
                                        .badHabits[keys[currentIndex]]
                                            ['startDate']
                                        .runtimeType ==
                                    DateTime
                                ? progressProvider.badHabits[keys[currentIndex]]
                                    ['startDate']
                                : progressProvider.badHabits[keys[currentIndex]]
                                        ['startDate']
                                    .toDate())
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(AppLocalizations.of(context)!.noHabits, style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center,),
                          Text(AppLocalizations.of(context)!.addNewPlus, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
