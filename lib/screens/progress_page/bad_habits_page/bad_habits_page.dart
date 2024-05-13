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

class BadHabitsPage extends StatefulWidget {
  const BadHabitsPage({super.key});

  @override
  State<BadHabitsPage> createState() => _BadHabitsPageState();
}

class _BadHabitsPageState extends State<BadHabitsPage> {
  int currentIndex = 0;

  Future<bool?> wantToRestartHabit(BuildContext context) async {
    bool? restartHabit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restart timer?', style: Theme.of(context).textTheme.bodySmall,),
          content: Text('Are you sure you want to restart timer for this bad habit? You can\'t retrieve it after', style: Theme.of(context).primaryTextTheme.bodySmall),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes', style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        );
      },
    );
    return restartHabit;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    DateTime? selectedStartDate;
    List<dynamic>? keys;
    if(progressProvider.badHabits.length!=0){
        keys = progressProvider.badHabits.keys.toList();
      selectedStartDate = progressProvider.badHabits[keys[currentIndex]]['startDate'].runtimeType != DateTime? progressProvider.badHabits[keys[currentIndex]]['startDate'].toDate():progressProvider.badHabits[keys[currentIndex]]['startDate'];
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
                            Text('Want to talk about it?',
                                style: Theme.of(context).textTheme.bodyLarge),
                            Text(
                              'No matter what, I\'ll always will be proud of you!',
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
              progressProvider.badHabits.length!=0?Container(
                height: height*0.3,
                child: CarouselSlider.builder(
                  itemCount: progressProvider.badHabits.length,
                  itemBuilder: (context, index, pageViewIndex) {
                    return Image.asset(
                        'assets/bad habits/${keys![index].toLowerCase()}.png');
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
              ):Text('Add new'),
              SizedBox(
                height: height * 0.015,
              ),
              progressProvider.badHabits.length!=0?AnimatedSmoothIndicator(
                activeIndex: currentIndex,
                count: keys!.length,
                effect: SlideEffect(

                    dotColor: Theme.of(context).colorScheme.primary,
                    activeDotColor: Theme.of(context).colorScheme.secondary),
              ):Container(),
              SizedBox(
                height: height * 0.015,
              ),
              progressProvider.badHabits.length!=0?Row(
                children: [
                  Text(
                    '${keys![currentIndex]} free for:',
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async{
                      bool? wantToRestart = await wantToRestartHabit(context);
                      if(wantToRestart == true){
                        progressProvider.restartBadHabit(keys![currentIndex], userProvider.user!.email!);
                      }
                    },
                    child: Icon(Icons.restart_alt),
                  ),
                  SizedBox(width: width*0.02,),
                  InkWell(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text(
                                'Select date',
                                style:
                                Theme.of(context).textTheme.bodyLarge,
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
                                        height: height*0.33,
                                        width: width*0.8,
                                        child: SfDateRangePicker(
                                          initialSelectedDate: selectedStartDate,
                                          initialDisplayDate: selectedStartDate,
                                          todayHighlightColor: Theme.of(context).colorScheme.secondary,
                                          selectableDayPredicate: (DateTime dateTime) {
                                            if (dateTime.isAfter(DateTime.now())) {
                                              return false;
                                            }
                                            return true;
                                          },
                                          onCancel: () {
                                            Navigator.pop(context);
                                          },
                                          selectionColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          onSelectionChanged: (arg) {
                                            setState(() {
                                              selectedStartDate = arg.value;
                                            });
                                          },
                                          // selectionShape: DateRangePickerSelectionShape.rectangle,
                                          showNavigationArrow: true,
                                          monthViewSettings:
                                          const DateRangePickerMonthViewSettings(
                                              firstDayOfWeek: 1),
                                          // onSelectionChanged: ,
                                          selectionMode:
                                          DateRangePickerSelectionMode.single,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: Theme.of(context).primaryTextTheme.labelLarge,
                                              )),
                                          TextButton(
                                              onPressed:
                                              selectedStartDate !=
                                                  null
                                                  ? () async{
                                                await progressProvider.changeBadHabitStart(keys![currentIndex], userProvider.user!.email!, selectedStartDate!);
                                                Navigator.pop(context);
                                              }
                                                  : null,
                                              child: Text(
                                                'Submit',
                                                style: selectedStartDate !=
                                                    null
                                                    ? Theme.of(context).primaryTextTheme.labelLarge!
                                                    .copyWith(
                                                    color:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary)
                                                    : Theme.of(context)
                                                    .primaryTextTheme
                                                    .labelLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(Icons.settings),
                  )
                ],
              ):Container(),
              SizedBox(height: height*0.015,),
              progressProvider.badHabits.length!=0?SobrietyTimer(sobrietyDate: progressProvider.badHabits[keys![currentIndex]]['startDate'].runtimeType == DateTime?progressProvider.badHabits[keys[currentIndex]]['startDate']:progressProvider.badHabits[keys[currentIndex]]['startDate'].toDate()):Container(),
            ],
          ),
        ),
      ),
    );
  }
}
