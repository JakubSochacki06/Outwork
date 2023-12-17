import 'package:flutter/material.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:outwork/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';

class DailyCheckinBox extends StatelessWidget {
  final String text;
  final String emojiName;
  final int value;
  final String unit;
  final int maximum;
  final int step;
  final List<Color> colorsGradient;
  final bool hasButtons;

  DailyCheckinBox({
    required this.value,
    required this.maximum,
    required this.unit,
    required this.text,
    required this.step,
    required this.emojiName,
    required this.colorsGradient,
    required this.hasButtons,
  });

  Map<String, int> _getValues(BuildContext context) {
    int currentMaximum = maximum;
    int currentValue = value;

    if (text == 'Morning Routine') {
      final morningRoutineProvider =
      Provider.of<MorningRoutineProvider>(context, listen: true);
      currentValue = morningRoutineProvider.countProgress();
      currentMaximum = morningRoutineProvider.morningRoutines.length;
    } else if (text == 'Night Routine') {
      final nightRoutineProvider =
      Provider.of<NightRoutineProvider>(context, listen: true);
      currentValue = nightRoutineProvider.countProgress();
      currentMaximum = nightRoutineProvider.nightRoutines.length;
    }

    return {'maximum': currentMaximum, 'value': currentValue};
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final values = _getValues(context);
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFEDEDED)),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(3, 3),
            ),
          ],
        ),
        height: height * 0.32,
        width: width * 0.50,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFEDEDED),
                      radius: 20,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.transparent,
                        child: Image.asset('assets/emojis/$emojiName.png'),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Expanded(
                      child: Text(
                        text,
                        style: kRegular16,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.1,
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        showTicks: false,
                        showLabels: false,
                        minimum: 0,
                        maximum: values['maximum']!.toDouble(),
                        annotations: [
                          GaugeAnnotation(
                            angle: 90,
                            widget: Center(
                              child: Text(
                                '${values['value']}/${values['maximum']}\n$unit',
                                style: kBold16,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: values['value']!.toDouble(),
                            sizeUnit: GaugeSizeUnit.logicalPixel,
                            gradient: SweepGradient(
                                colors: colorsGradient,
                                stops: <double>[0.25, 0.75]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                hasButtons==true?Container(
                  height: height*0.04,
                  width: width*0.25,
                  decoration: BoxDecoration(
                      color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){print('minus');},
                        child: Container(
                          child: Icon(Icons.remove, color: Colors.white,),
                          height: height*0.04,
                          width: width*0.12,
                        ),
                      ),
                      Container(
                        height: height*0.02,
                        width: width*0.005,
                        color: Colors.white,
                      ),
                      InkWell(
                        onTap: (){
                          userProvider.addDailyCheckinProgressToFirebase(step, text);
                        },
                        child: Container(
                          child: Icon(Icons.add, color: Colors.white,),
                          height: height*0.04,
                          width: width*0.12,
                        ),
                      ),
                    ],
                  ),
                ):Container(
                  child: Text('You can do it', style: kRegular20,),
                  height: height*0.04,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
