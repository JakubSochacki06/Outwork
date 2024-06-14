import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoodLinearChart extends StatefulWidget {
  const MoodLinearChart({super.key});

  @override
  State<MoodLinearChart> createState() => _MoodLinearChartState();
}

class _MoodLinearChartState extends State<MoodLinearChart> {
  int amountOfMoods = 7;

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider =
    Provider.of<JournalEntryProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Map<DateTime, String> datesAndFeelings =
    journalEntryProvider.getDatesAndFeelings();
    amountOfMoods =
    datesAndFeelings.length < 7 ? datesAndFeelings.length : amountOfMoods;
    List<DateTime> chosenAmountOfSortedDates = datesAndFeelings.keys
        .toList()
        .reversed
        .toList()
        .sublist(0, amountOfMoods)
        .reversed
        .toList();
    List<String> chosenAmountOfSortedFeelings = datesAndFeelings.values
        .toList()
        .reversed
        .toList()
        .sublist(0, amountOfMoods)
        .reversed
        .toList();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Color> gradientColors = [Colors.red, Colors.orange, Colors.green];

    List<FlSpot> spots = [];
    List<FlSpot> dummySpots = [
      FlSpot(0, 4),
      FlSpot(1, 2),
      FlSpot(2, 4),
      FlSpot(3, 3),
      FlSpot(4, 5),
    ];

    void setSpots() {
      spots = [];
      for (int i = 0; i < chosenAmountOfSortedFeelings.length; i++) {
        spots.add(FlSpot(
            i.toDouble(),
            journalEntryProvider
                .getNumberAsFeeling(chosenAmountOfSortedFeelings[i])
                .toDouble()));
      }
    }

    double getInterval() {
      switch (amountOfMoods) {
        case 7:
          return 1;
        case 14:
          return 2;
        case 30:
          return 3.5;
        case 90:
          return 9;
        default:
          return 1;
      }
    }

    Widget bottomTitleWidgets(double value, TitleMeta meta) {
      Widget? text;
      if (value == 13) {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: const Text(''),
        );
      }
      if (!(value > datesAndFeelings.keys.toList().length)) {
        if (value < amountOfMoods) {
          DateTime date = chosenAmountOfSortedDates.toList()[value.toInt()];
          text = Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              '${date.day}.${DateFormat('MM').format(date)}',
              style: Theme.of(context).primaryTextTheme.labelSmall,
            ),
          );
        }
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text!,
      );
    }

    Widget bottomTitleDummyWidgets(double value, TitleMeta meta) {
      List<DateTime> dummyDateTimes = [
        DateTime(2024, 3, 14),
        DateTime(2024, 3, 15),
        DateTime(2024, 3, 16),
        DateTime(2024, 3, 17),
        DateTime(2024, 3, 18),
      ];

      Widget? text;

      if (value == 13) {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: const Text(''),
        );
      }

      if (!(value > dummyDateTimes.length)) {
        if (value < 7) {
          DateTime date = dummyDateTimes[value.toInt()];
          text = Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              '${date.day}.${DateFormat('MM').format(date)}',
              style: Theme.of(context).primaryTextTheme.labelSmall,
            ),
          );
        }
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text!,
      );
    }

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      List<String> emojiNames = [
        'sad',
        'unhappy',
        'neutral',
        'happy',
        'veryhappy'
      ];

      return Container(
        // width: 30,
        // height: 30,
        child:
        Image.asset('assets/emojis/${emojiNames[value.toInt() - 1]}.png'),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
      );
    }

    LineChartData mainData() {
      return LineChartData(
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: getInterval(),
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black12),
        ),
        minX: 0,
        maxX: amountOfMoods - 1,
        minY: 1,
        maxY: 5,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.55,
            preventCurveOverShooting: true,
            gradient: const LinearGradient(
              // stops: [1,3,5],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.red, Colors.orange, Colors.green],
            ),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 4,
                    color: Colors.black,
                    // strokeWidth: 2,
                    // strokeColor: Colors.black,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
              ),
            ),
          ),
        ],
      );
    }

    LineChartData dummyData() {
      return LineChartData(
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: 1,
              getTitlesWidget: bottomTitleDummyWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black12),
        ),
        minX: 0,
        maxX: 4,
        minY: 1,
        maxY: 5,
        lineBarsData: [
          LineChartBarData(
            spots: dummySpots,
            isCurved: true,
            curveSmoothness: 0.55,
            preventCurveOverShooting: true,
            gradient: const LinearGradient(
              // stops: [1,3,5],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.red, Colors.orange, Colors.green],
            ),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 4,
                    color: Colors.black,
                    // strokeWidth: 2,
                    // strokeColor: Colors.black,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
              ),
            ),
          ),
        ],
      );
    }

    setSpots();
    return datesAndFeelings.length >= 2
        ? Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.yourFeelingsChart,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: datesAndFeelings.length >= 7
                              ? () {
                            setState(() {
                              amountOfMoods = 7;
                            });
                          }
                              : null,
                          child: Text(
                            AppLocalizations.of(context)!.lastMoods(7),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary),
                          )),
                      TextButton(
                          onPressed: datesAndFeelings.length >= 14
                              ? () {
                            setState(() {
                              amountOfMoods = 14;
                            });
                          }
                              : null,
                          child: Text(
                            AppLocalizations.of(context)!.lastMoods(14),
                            style: datesAndFeelings.length > 14
                                ? Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary)
                                : Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              if (datesAndFeelings.length < 30) {
                                // final snackBar = SnackBar(
                                //   elevation: 0,
                                //   behavior: SnackBarBehavior.floating,
                                //   backgroundColor: Colors.transparent,
                                //   content: AwesomeSnackbarContent(
                                //     title: 'On Snap!',
                                //     message:
                                //     'You don\'t have enough day ratings to see this chart!',
                                //     contentType: ContentType.failure,
                                //   ),
                                // );
                                //
                                // ScaffoldMessenger.of(context)
                                //   ..hideCurrentSnackBar()
                                //   ..showSnackBar(snackBar);
                              } else {
                                amountOfMoods = 30;
                              }
                            });
                          },
                          child: Text(
                            AppLocalizations.of(context)!.lastMoods(30),
                            style: datesAndFeelings.length > 30
                                ? Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary)
                                : Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              if (datesAndFeelings.length < 90) {
                                // final snackBar = SnackBar(
                                //   elevation: 0,
                                //   behavior: SnackBarBehavior.floating,
                                //   backgroundColor: Colors.transparent,
                                //   content: AwesomeSnackbarContent(
                                //     title: 'On Snap!',
                                //     message:
                                //     'You don\'t have enough day ratings to see this chart!',
                                //     contentType: ContentType.failure,
                                //   ),
                                // );
                                //
                                // ScaffoldMessenger.of(context)
                                //   ..hideCurrentSnackBar()
                                //   ..showSnackBar(snackBar);
                              } else {
                                amountOfMoods = 90;
                              }
                            });
                          },
                          child: Text(
                            AppLocalizations.of(context)!.lastMoods(90),
                            style: datesAndFeelings.length > 90
                                ? Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary)
                                : Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                flex: 5,
                child: LineChart(
                  mainData(),
                ),
              ),
            ],
          ),
        ),
      ],
    )
        : Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: 2, sigmaY: 2, tileMode: TileMode.decal),
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.5,
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourFeelingsChart,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  AppLocalizations.of(context)!.lastMoods(7),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                )),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  AppLocalizations.of(context)!.lastMoods(14),
                                  style: datesAndFeelings.length > 14
                                      ? Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary)
                                      : Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                )),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  AppLocalizations.of(context)!.lastMoods(30),
                                  style: datesAndFeelings.length > 30
                                      ? Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary)
                                      : Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                )),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  AppLocalizations.of(context)!.lastMoods(90),
                                  style: datesAndFeelings.length > 90
                                      ? Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary)
                                      : Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Expanded(
                      flex: 5,
                      child: LineChart(
                        dummyData(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: width*0.65,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.85),
                border: themeProvider.isLightTheme()
                    ? Border.all(color: const Color(0xFFEDEDED))
                    : null,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: themeProvider.isLightTheme()
                    ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(3, 3),
                  ),
                ]
                    : null,
              ),
              child: Text(AppLocalizations.of(context)!.addAtleastNotes, textAlign: TextAlign.center,),
            ),
          ),
        ),
      ],
    );
  }
}