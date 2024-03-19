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
import 'package:outwork/widgets/mood_chart.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context);
    return Scaffold(
      appBar: ProfileAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: height * 0.02, left: width * 0.04, right: width * 0.04),
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
                      Text(
                        userProvider.user!.displayName!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(xpLevelProvider.getUserLevelDescription(),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimaryContainer)),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      LinearPercentIndicator(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        barRadius: Radius.circular(15),
                        progressColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        percent: xpLevelProvider.levelProgress,
                        animation: true,
                        leading: Container(
                          width: width * 0.07,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Center(
                            child: Text(
                              xpLevelProvider.xpLevel.toString(),
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimaryContainer),
                          )),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            MoodLinearChart(),
            // PRO ACCESS
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 0, tileMode: TileMode.decal),
              child: Column(
                children: [
                  WorkedTimeInfo(),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  StressLevelInfo(),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  MostFeltEmotionInfo(),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  MoodChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
