import 'package:flutter/material.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/appBars/profile_app_bar.dart';
import 'package:outwork/widgets/mood_linear_chart.dart';
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userProvider.user!.displayName!, style: Theme.of(context).textTheme.bodyMedium,),
                    Text('Outwork all of them', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary)),
                    SizedBox(height: height*0.002,),
                    LinearPercentIndicator(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      barRadius: Radius.circular(15),
                      progressColor:
                      Theme.of(context).colorScheme.secondary,
                      backgroundColor:
                      Theme.of(context).colorScheme.primary,
                      width: width * 0.55,
                      percent: 0.4,
                      animation: true,
                      leading: Container(
                        width: width*0.07,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Center(
                          child: Text(
                            userProvider.user!.level.toString(),
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: height*0.01,),
            Text('Your feeling charts', style: Theme.of(context).textTheme.bodyMedium,),
            SizedBox(height: height*0.01,),
            MoodLinearChart(),
            SizedBox(height: height*0.01,),
            WorkedTimeInfo(),
            SizedBox(height: height*0.01,),
            StressLevelInfo(),
            SizedBox(height: height*0.01,),
            MoodChart(),
          ],
        ),
      ),
    );
  }
}
