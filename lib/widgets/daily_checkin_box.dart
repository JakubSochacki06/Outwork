import 'package:flutter/material.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:outwork/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';


class DailyCheckinBox extends StatelessWidget {
  int maximum;
  int value;
  // TODO: ZFIXOWAC TUTAJ Z KLASA FINALNA
  final String text;
  final String emojiName;
  final Color colorGradient1;
  final Color colorGradient2;
  DailyCheckinBox({required this.maximum, required this.value, required this.text, required this.emojiName, required this.colorGradient1, required this.colorGradient2});

  @override
  Widget build(BuildContext context) {
    if(text == 'Morning Routine') {
      final morningRoutineProvider =
      Provider.of<MorningRoutineProvider>(context, listen: true);
      value = morningRoutineProvider.countProgress();
      maximum = morningRoutineProvider.morningRoutines.length;
    } else if(text == 'Night Routine'){
      final nightRoutineProvider =
      Provider.of<NightRoutineProvider>(context, listen: true);
      value = nightRoutineProvider.countProgress();
      maximum = nightRoutineProvider.nightRoutines.length;
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFEDEDED)),
            // color: Color(0xFFF0F2F5),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 3,
                // blurRadius: 10,
                offset: Offset(3, 3),
              )
            ]),
        height: height * 0.3,
        width: width * 0.45,
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
                      child: Image.asset(
                        'assets/emojis/$emojiName.png',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: kRegular16,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.1,
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      showTicks: false,
                      showLabels: false,
                      minimum: 0,
                      maximum: maximum.toDouble(),

                      annotations: [
                        GaugeAnnotation(widget: Center(child: Text('$value/$maximum')))
                      ],
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: value.toDouble(),
                          // width: constraints.maxWidth/20,
                          sizeUnit: GaugeSizeUnit.logicalPixel,
                          gradient: SweepGradient(colors: <Color>[
                            colorGradient1,
                            colorGradient2
                          ], stops: <double>[
                            0.25,
                            0.75
                          ]),
                        )
                      ]),
                ]),
              ),
            ],
          );
        }),
      ),
    );
  }
}
