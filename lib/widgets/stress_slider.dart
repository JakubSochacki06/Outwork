import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:provider/provider.dart';

class StressSlider extends StatelessWidget {
  final JournalEntry subject;
  StressSlider({required this.subject});

  @override
  Widget build(BuildContext context) {
    return ShapeCustomizedSliderPage(subject: subject,);
  }
}

class ShapeCustomizedSliderPage extends StatefulWidget {
  final JournalEntry subject;
  ShapeCustomizedSliderPage({required this.subject});

  @override
  ShapeCustomizedSliderPageState createState() =>
      ShapeCustomizedSliderPageState();
}

class ShapeCustomizedSliderPageState extends State<ShapeCustomizedSliderPage> {
  ShapeCustomizedSliderPageState();

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider diaryEntryProvider = Provider.of<JournalEntryProvider>(context);
    const double min = 0.0;
    const double max = 10.0;
    double value = widget.subject.stressLevel!.toDouble();
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double padding = MediaQuery.of(context).size.width / 150.0;
            return Container(
              padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SfSliderTheme(
                    data: SfSliderThemeData(
                      brightness: Brightness.light,
                    ),
                    child: SfSlider(
                      min: min,
                      max: max,
                      value: value,
                      interval: 2.0,
                      showLabels: true,
                      minorTicksPerInterval: 1,
                      stepSize: 1,
                      showTicks: true,
                      trackShape: _SfTrackShape(min, max),
                      thumbShape: _SfThumbShape(min, max),
                      onChanged: (dynamic value) {
                        setState(() {
                          value = value as double;
                          diaryEntryProvider.setStressLevel(value.toInt(), widget.subject);
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

Color getColorBasedOnPercent(double percent){
  // if(percent > 70){
  //   return Colors.red;
  // } else if(percent >= 30){
  //   return Colors.yellow;
  // }
  // return Colors.green;
  if(percent<=50){
    return Colors.green;
  }
  return Colors.red;
}
class _SfTrackShape extends SfTrackShape {
  _SfTrackShape(dynamic min, dynamic max) {
    this.min = (min.runtimeType == DateTime
        ? min.millisecondsSinceEpoch.toDouble()
        : min) as double;
    this.max = (max.runtimeType == DateTime
        ? max.millisecondsSinceEpoch.toDouble()
        : max) as double;
  }

  late double min;
  late double max;
  double? trackIntermediatePos;

  @override
  void paint(PaintingContext context, Offset offset, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
        required SfSliderThemeData themeData,
        SfRangeValues? currentValues,
        dynamic currentValue,
        required Animation<double> enableAnimation,
        required Paint? inactivePaint,
        required Paint? activePaint,
        required TextDirection textDirection}) {
    final Rect trackRect = getPreferredRect(parentBox, themeData, offset);
    final double actualValue = (currentValue.runtimeType == DateTime
        ? currentValue.millisecondsSinceEpoch.toDouble()
        : currentValue) as double;
    final double actualValueInPercent =
        ((actualValue - min) * 100) / (max - min);
    trackIntermediatePos = _getTrackIntermediatePosition(trackRect);

    // low volume track.
    final Paint trackPaint = Paint();
    trackPaint.color = getColorBasedOnPercent(actualValueInPercent);
    final Rect lowVolumeRect = Rect.fromLTRB(
        trackRect.left, trackRect.top, thumbCenter!.dx, trackRect.bottom);
    context.canvas.drawRect(lowVolumeRect, trackPaint);

    if (actualValueInPercent <= 50.0) {
      trackPaint.color = Colors.green.withOpacity(0.40);
      final Rect lowVolumeRectWithLessOpacity = Rect.fromLTRB(thumbCenter.dx,
          trackRect.top, trackIntermediatePos!, trackRect.bottom);
      context.canvas.drawRect(lowVolumeRectWithLessOpacity, trackPaint);
      // print('ZIELONY');
      // print(thumbCenter.dx);
      // print(trackRect.top);
      // print(trackIntermediatePos!);
      // print(trackPaint);

    }
    // if (actualValueInPercent > 30.0 && actualValueInPercent < 70.0) {
    //   trackPaint.color = Colors.yellow.withOpacity(0.40);
    //   final Rect lowVolumeRectWithLessOpacity = Rect.fromLTRB(thumbCenter.dx,
    //       trackRect.top, trackIntermediatePos!, trackRect.bottom);
    //   context.canvas.drawRect(lowVolumeRectWithLessOpacity, trackPaint);
    //
    // }
    trackPaint.color = Colors.red.withOpacity(0.40);
    final double highTrackLeft =
    actualValueInPercent > 50.0 ? thumbCenter.dx : trackIntermediatePos!;
    final Rect highVolumeRectWithLessOpacity = Rect.fromLTRB(highTrackLeft,
        trackRect.top, trackRect.width + trackRect.left, trackRect.bottom);
    context.canvas.drawRect(highVolumeRectWithLessOpacity, trackPaint);
    // print('CZERWONY');
    // print(highTrackLeft);
    // print(thumbCenter.dx);
    // print(trackRect.top);
    // print(trackIntermediatePos!);
    // print(trackPaint);
  }

  double _getTrackIntermediatePosition(Rect trackRect) {
    final double actualValue = ((50 * (max - min)) + min) / 100;
    return (((actualValue - min) / (max - min)) * trackRect.width) +
        trackRect.left;
  }
}

class _SfThumbShape extends SfThumbShape {
  _SfThumbShape(dynamic min, dynamic max) {
    this.min = (min.runtimeType == DateTime
        ? min.millisecondsSinceEpoch.toDouble()
        : min) as double;
    this.max = (max.runtimeType == DateTime
        ? max.millisecondsSinceEpoch.toDouble()
        : max) as double;
  }

  late double min;
  late double max;

  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox,
        required RenderBox? child,
        required SfSliderThemeData themeData,
        SfRangeValues? currentValues,
        dynamic currentValue,
        required Paint? paint,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required SfThumb? thumb}) {
    final double actualValue = (currentValue.runtimeType == DateTime
        ? currentValue.millisecondsSinceEpoch.toDouble()
        : currentValue) as double;

    final double actualValueInPercent =
        ((actualValue - min) * 100) / (max - min);

    paint = Paint();
    paint.color = getColorBasedOnPercent(actualValueInPercent);

    super.paint(context, center,
        parentBox: parentBox,
        themeData: themeData,
        currentValue: currentValue,
        paint: paint,
        enableAnimation: enableAnimation,
        textDirection: textDirection,
        thumb: thumb,
        child: child);
  }
}