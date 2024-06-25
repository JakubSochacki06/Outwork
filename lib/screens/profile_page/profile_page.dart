import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/widgets/appBars/profile_app_bar.dart';
import 'package:outwork/widgets/mood_linear_chart.dart';
import 'package:outwork/widgets/most_felt_emotion_info.dart';
import 'package:outwork/widgets/stress_level_info.dart';
import 'package:outwork/widgets/work_time_info.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/refer_box.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context);
    return Scaffold(
      appBar: const ProfileAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.02, horizontal: width * 0.04),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: width * 0.085,
                  backgroundImage: NetworkImage(userProvider.user!.photoURL!),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProvider.user!.displayName!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                xpLevelProvider.getUserLevelDescription(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                              ),
                            ],
                          ),
                          buildStreakWidget(userProvider.user!.streak!, context)
                        ],
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      LinearPercentIndicator(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        barRadius: const Radius.circular(15),
                        progressColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        percent: xpLevelProvider.levelProgress,
                        animation: true,
                        leading: Container(
                          width: width * 0.07,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Center(
                            child: Text(
                              xpLevelProvider.xpLevel.toString()!=null?xpLevelProvider.xpLevel.toString():"0",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            '${xpLevelProvider.xpAmount}/${xpLevelProvider.getNextLevelThreshold()}',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                          )),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            const MoodLinearChart(),
            // ReferBox(),
            SizedBox(
              height: height * 0.01,
            ),
            // PRO ACCESS
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                  sigmaX: 0, sigmaY: 0, tileMode: TileMode.decal),
              child: Column(
                children: [
                  const WorkedTimeInfo(),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  const StressLevelInfo(),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  const MostFeltEmotionInfo(),
                  SizedBox(
                    height: height * 0.01,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildStreakWidget(int streakAmount, context) {
  if (streakAmount == 0) {
    return Image.asset(
      'assets/images/streaks/nostreak.png',
      scale: 9,
    );
  } else if (streakAmount > 9) {
    return Image.asset(
      'assets/images/streaks/superstreak.png',
      scale: 9,
    );
  } else {
    return Stack(
      children: [
        Image.asset(
          'assets/images/streaks/streak.png',
          scale: 9,
        ),
        Positioned.fill(
          top: 15,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              streakAmount.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );


  }
}
