import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/string_extension.dart';
import 'package:provider/provider.dart';

class MoodChart extends StatefulWidget {
  const MoodChart({super.key});

  @override
  State<MoodChart> createState() => _MoodChartState();
}

class _MoodChartState extends State<MoodChart> {
  int? touchedIndex;
  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context);
    Map<String, int> feelingsAmount = journalEntryProvider.getFeelingsAmount();
    String averageMood = journalEntryProvider.getAverageMood();



    List<PieChartSectionData> showingSections() {
      List <PieChartSectionData> pieCharts = [];
      int index = 0;
      feelingsAmount.forEach((key, value) {
        bool isTouched = index == touchedIndex;
        double fontSize = isTouched ? 20.0 : 16.0;
        double radius = isTouched ? 110.0 : 100.0;
        double widgetSize = isTouched ? 55.0 : 40.0;
        index++;
        pieCharts.add(
          PieChartSectionData(
            color: journalEntryProvider.getColorByFeeling(key),
            value: value.toDouble(),
            title: '${(value*100/journalEntryProvider.journalEntries.length).round()}%',
            radius: radius,
            titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: fontSize),
            badgeWidget: _Badge(
              'assets/emojis/$key.png',
              size: widgetSize,
              borderColor: Colors.transparent,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            badgePositionPercentageOffset: .98,
          )
        );
      });

      return pieCharts;
    }

    return Column(
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Total moods chart',
            // style: kStatsPageTitle,
          ),
        ),
        feelingsAmount.isNotEmpty
            ? AspectRatio(
                aspectRatio: 1.5,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      sections: showingSections(),
                    ),
                  ),
                ),
              )
            : const Text(
                'Submit more day ratings and see stats about your main feelings!',
              ),
        averageMood.length != 0
            ? Align(
                alignment: Alignment.center,
                child: Text(
                  'Average feeling: ${averageMood.capitalize()}\nHere is advice for you:',
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
        // Align(
        //   alignment: Alignment.center,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(15.0),
        //       border: Border.all(color: adviceBorderColor, width: 1.5),
        //       color: adviceBackgroundColor,
        //     ),
        //     child: adviceFuture != null
        //         ? FutureBuilder(
        //       future: adviceFuture,
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData) {
        //           return Padding(
        //             padding: EdgeInsets.all(10.0),
        //             child: Column(
        //               children: [
        //                 Text(
        //                   '${snapshot.data}',
        //                   style: kHomePageQuoteText,
        //                 ),
        //               ],
        //             ),
        //           );
        //         } else {
        //           return Padding(
        //             padding: EdgeInsets.all(10.0),
        //             child: Text('No internet connection'),
        //           );
        //         }
        //       },
        //     )
        //         : Padding(
        //       padding: EdgeInsets.all(10.0),
        //       child: Column(
        //         children: [
        //           Text(
        //             'Submit more day ratings and see the advice for you!',
        //             style: kHomePageQuoteText,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.emojiPath, {
    required this.size,
    required this.borderColor,
    required this.backgroundColor,
  });

  final String emojiPath;
  final double size;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: Image.asset(emojiPath)),
    );
  }
}
