import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';


class MoodLinearChart extends StatefulWidget {
  const MoodLinearChart({super.key});

  @override
  State<MoodLinearChart> createState() => _MoodLinearChartState();
}

class _MoodLinearChartState extends State<MoodLinearChart> {
  int amountOfMoods = 7;

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Map<DateTime, String> datesAndFeelings = journalEntryProvider.getDatesAndFeelings();
    amountOfMoods = datesAndFeelings.length<7?datesAndFeelings.length:amountOfMoods;
    List<DateTime> chosenAmountOfSortedDates = datesAndFeelings.keys.toList().reversed.toList().sublist(0, amountOfMoods).reversed.toList();
    List<String> chosenAmountOfSortedFeelings = datesAndFeelings.values.toList().reversed.toList().sublist(0, amountOfMoods).reversed.toList();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // List<DateTime> sortedKeys = datesAndFeelings.keys.toList();
    // sortedKeys.sort();
    List<Color> gradientColors = [Colors.red, Colors.orange, Colors.green];

    List<FlSpot> spots = [];

    void setSpots() {
      spots = [];
      for (int i = 0; i < chosenAmountOfSortedFeelings.length; i++) {
        spots.add(FlSpot(i.toDouble(), journalEntryProvider.getNumberAsFeeling(chosenAmountOfSortedFeelings[i]).toDouble()));
      }
    }

    double getInterval(){
      print(amountOfMoods);
      switch(amountOfMoods){
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
      if(value == 13){
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(''),
        );
      }
      if (!(value > datesAndFeelings.keys.toList().length)) {
        if (value < amountOfMoods) {
          DateTime date = chosenAmountOfSortedDates.toList()[value.toInt()];
          text = Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: Text('${date.day}.${DateFormat('MM').format(date)}', style: Theme.of(context).primaryTextTheme.labelSmall,),
          );
        }
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text!,
      );
    }

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      List<String> emojiNames = ['sad', 'unhappy', 'neutral', 'happy', 'veryhappy'];

      return Container(
        width: 30,
        height: 30,
        child: Image.asset('assets/emojis/${emojiNames[value.toInt()-1]}.png'),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      );
    }

    LineChartData mainData() {
      return LineChartData(
        lineTouchData: LineTouchData(
          enabled: false
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
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
            gradient: LinearGradient(
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
    return datesAndFeelings.length>=2?Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.7,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: datesAndFeelings.length>=7?() {
                            setState(() {
                              amountOfMoods = 7;
                            });
                            }:null,
                          child: Text('Last 7 moods', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.secondary),)),
                      TextButton(
                          onPressed: datesAndFeelings.length>=14?() {
                            setState(() {
                              amountOfMoods = 14;
                            });
                          }:null,
                          child: Text('Last 14 moods', style: datesAndFeelings.length>14?Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.secondary):Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),)),
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
                          child: Text('Last 30 moods', style: datesAndFeelings.length>30?Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.secondary):Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),)),
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
                          child: Text('Last 90 moods', style: datesAndFeelings.length>90?Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.secondary):Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height*0.01,
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
    ):Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: themeProvider.isLightTheme() ? Border.all(color: Color(0xFFEDEDED)) : null,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: themeProvider.isLightTheme()
            ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(3, 3),
          ),
        ]
            : null,
      ),
      child: Center(child: Text('Add atleast 2 notes to track your feelings!', style: Theme.of(context).primaryTextTheme.bodyMedium, textAlign: TextAlign.center,)),
    );
  }
}