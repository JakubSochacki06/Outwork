import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:outwork/text_styles.dart';

class DailyCheckinBox extends StatelessWidget {
  final int maximum;
  final int value;
  const DailyCheckinBox({required this.maximum, required this.value});

  @override
  Widget build(BuildContext context) {
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
                        'assets/emojis/morning.png',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Morning Routine',
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
                          gradient: const SweepGradient(colors: <Color>[
                            Color(0xFFCC2B5E),
                            Color(0xFF753A88)
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
