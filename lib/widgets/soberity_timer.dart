import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:outwork/widgets/custom_linear_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';

class SobrietyTimer extends StatefulWidget {
  final DateTime sobrietyDate;

  const SobrietyTimer({Key? key, required this.sobrietyDate}) : super(key: key);

  @override
  State<SobrietyTimer> createState() => _SobrietyTimerState();
}

class _SobrietyTimerState extends State<SobrietyTimer> {
  Timer? _timer;
  Period _duration = Period.zero;

  @override
  void initState() {
    super.initState();
    _updateTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateTimer());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimer() {
    LocalDateTime now = LocalDateTime.now();
    Period difference = now.periodSince(LocalDateTime.dateTime(widget.sobrietyDate));
    setState(() {
      _duration = difference;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int years = _duration.years;
    int months = _duration.months;
    int days = _duration.days;
    int hours = _duration.hours;
    int minutes = _duration.minutes;
    int seconds = _duration.seconds;

    List<Widget> timeComponents = [];
    if (years > 0) {
      timeComponents.add(
        Stack(
          children: [
            CustomLinearPercentIndicator(
              lineHeight: height * 0.05,
              animateFromLastPercent: true,
              animation: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              progressColor: Theme.of(context).colorScheme.secondary,
              barRadiusBottomRight: Radius.elliptical(70, 100),
              percent: years / 25,
              padding: EdgeInsets.zero,
            ),
            Positioned(
              left: 10,
              top: 5,
              child: RichText(
                text: TextSpan(
                    text: years.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                          text: ' Years',
                          style: Theme.of(context).primaryTextTheme.bodyMedium)
                    ]),
              ),
            ),
          ],
        ),
      );
    }
    if (months > 0) {
      timeComponents.add(
        Stack(
          children: [
            CustomLinearPercentIndicator(
              lineHeight: height * 0.05,
              animateFromLastPercent: true,
              animation: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              progressColor: Theme.of(context).colorScheme.secondary,
              barRadiusBottomRight: Radius.elliptical(70, 100),
              percent: months / 12,
              padding: EdgeInsets.zero,
            ),
            Positioned(
              left: 10,
              top: 5,
              child: RichText(
                text: TextSpan(
                    text: months.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                          text: ' Months',
                          style: Theme.of(context).primaryTextTheme.bodyMedium)
                    ]),
              ),
            ),
          ],
        ),
      );
    }
    if (days > 0) {
      timeComponents.add(
        Stack(
          children: [
            CustomLinearPercentIndicator(
              lineHeight: height * 0.05,
              animateFromLastPercent: true,
              animation: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              progressColor: Theme.of(context).colorScheme.secondary,
              barRadiusBottomRight: Radius.elliptical(70, 100),
              percent: days / 30,
              padding: EdgeInsets.zero,
            ),
            Positioned(
              left: 10,
              top: 5,
              child: RichText(
                text: TextSpan(
                    text: days.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                          text: ' Days',
                          style: Theme.of(context).primaryTextTheme.bodyMedium)
                    ]),
              ),
            ),
          ],
        ),
      );
    }
    if (hours > 0) {
      timeComponents.add(
        Stack(
          children: [
            CustomLinearPercentIndicator(
              lineHeight: height * 0.05,
              animateFromLastPercent: true,
              animation: true,
              percent: hours / 24,
              backgroundColor: Theme.of(context).colorScheme.primary,
              progressColor: Theme.of(context).colorScheme.secondary,
              barRadiusBottomRight: Radius.elliptical(70, 100),
              padding: EdgeInsets.zero,
            ),
            Positioned(
              left: 10,
              top: 5,
              child: RichText(
                text: TextSpan(
                    text: hours.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                          text: ' Hours',
                          style: Theme.of(context).primaryTextTheme.bodyMedium)
                    ]),
              ),
            ),
          ],
        ),
      );
    }
    if (minutes > 0) {
      timeComponents.add(
        Stack(
          children: [
            CustomLinearPercentIndicator(
              lineHeight: height * 0.05,
              animateFromLastPercent: true,
              animation: true,
              percent: minutes / 60,
              backgroundColor: Theme.of(context).colorScheme.primary,
              progressColor: Theme.of(context).colorScheme.secondary,
              barRadiusBottomRight: Radius.elliptical(70, 100),
              padding: EdgeInsets.zero,
            ),
            Positioned(
              left: 10,
              top: 5,
              child: RichText(
                text: TextSpan(
                    text: minutes.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                          text: ' Minutes',
                          style: Theme.of(context).primaryTextTheme.bodyMedium)
                    ]),
              ),
            ),
          ],
        ),
      );
    }
    timeComponents.add(
      Stack(
        children: [
          CustomLinearPercentIndicator(
            lineHeight: height * 0.05,
            animateFromLastPercent: true,
            animation: true,
            percent: seconds / 60,
            backgroundColor: Theme.of(context).colorScheme.primary,
            progressColor: Theme.of(context).colorScheme.secondary,
            barRadiusBottomRight: Radius.elliptical(70, 100),
            // linearGradient: LinearGradient(colors: [Color(0xFF3f5efb), Color(0xFFfc466b)]),
            padding: EdgeInsets.zero,
          ),
          Positioned(
            left: 10,
            top: 5,
            child: RichText(
              text: TextSpan(
                  text: seconds.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                        text: ' Seconds',
                        style: Theme.of(context).primaryTextTheme.bodyMedium)
                  ]),
            ),
          ),
        ],
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: timeComponents,
    );
  }
}
