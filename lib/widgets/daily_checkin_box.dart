import 'package:flutter/material.dart';
import 'package:outwork/models/daily_checkin.dart';
import 'package:outwork/providers/daily_checkin_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/add_daily_checkin_popup.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';

class DailyCheckinBox extends StatelessWidget {
  final int index;
  String? routineName;

  DailyCheckinBox({
    required this.index,
    this.routineName,
  });

  @override
  Widget build(BuildContext context) {

    DailyCheckinProvider dailyCheckinProvider = Provider.of<DailyCheckinProvider>(context, listen: true);
    int currentMaximum = 0;
    int currentValue = 0;
    DailyCheckin dailyCheckin = DailyCheckin();

    Map<String, dynamic> _getValues(BuildContext context) {

      bool hasRoutines = true;
      if (routineName == 'Morning') {
        final morningRoutineProvider =
        Provider.of<MorningRoutineProvider>(context, listen: true);
        dailyCheckin.name = 'Morning';
        dailyCheckin.emojiName = 'morning';
        dailyCheckin.step = 1;
        dailyCheckin.unit = 'routines';
        dailyCheckin.color = Color(0xFF6096B4);
        morningRoutineProvider.morningRoutines.length != 0 ?
        currentValue = morningRoutineProvider.countProgress() : 0;
        currentMaximum = morningRoutineProvider.morningRoutines.length != 0
            ? morningRoutineProvider.morningRoutines.length
            : 1;
        morningRoutineProvider.morningRoutines.length == 0
            ? hasRoutines = false
            : null;
      } else if (routineName == 'Night') {
        final nightRoutineProvider =
        Provider.of<NightRoutineProvider>(context, listen: true);
        dailyCheckin.name = 'Night';
        dailyCheckin.emojiName = 'bed';
        dailyCheckin.step = 1;
        dailyCheckin.unit = 'routines';
        dailyCheckin.color = Color(0xFFAC87C5);
        currentValue =
        nightRoutineProvider.nightRoutines.length != 0 ? nightRoutineProvider
            .countProgress() : 0;
        currentMaximum =
        nightRoutineProvider.nightRoutines.length != 0 ? nightRoutineProvider
            .nightRoutines.length : 1;
        nightRoutineProvider.nightRoutines.length == 0
            ? hasRoutines = false
            : null;
      } else {
        dailyCheckin = dailyCheckinProvider.dailyCheckins[index];
        currentValue = dailyCheckinProvider.dailyCheckins[index].value!;
        currentMaximum = dailyCheckinProvider.dailyCheckins[index].goal!;
      }

      return {'maximum': currentMaximum, 'value': currentValue, 'hasRoutines':hasRoutines};
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Map<String, dynamic> values = _getValues(context);
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: themeProvider.isLightTheme()?Border.all(color: Color(0xFFEDEDED)):null,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: themeProvider.isLightTheme()?[
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(3, 3),
          ),
        ]:null,
      ),
      height: height * 0.32,
      width: width * 0.50,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    radius: 20,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.transparent,
                      child: Image.asset('assets/emojis/dailycheckin/${dailyCheckin.emojiName}.png'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      dailyCheckin.name!,
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    child: routineName == null?IconButton(
                      onPressed: (){
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          builder: (context) => SingleChildScrollView(
                            child: Container(
                              // height: height*0.1,
                              padding: EdgeInsets.only(
                                  bottom:
                                  MediaQuery.of(context).viewInsets.bottom),
                              child: AddDailyCheckinPopup(buttonText: 'Edit existing', name: dailyCheckin.name!, unit: dailyCheckinProvider.dailyCheckins[index].unit!, goal: values['maximum'].toString(), step: dailyCheckinProvider.dailyCheckins[index].step.toString(), emoji: dailyCheckinProvider.dailyCheckins[index].emojiName!, id: dailyCheckinProvider.dailyCheckins[index].id!,),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.settings, color: Theme.of(context).iconTheme.color,),
                    ):Container(),
                  )
                ],
              ),
              SizedBox(
                height: width * 0.02,
              ),
              // Divider(
              //   thickness: 2,
              //   height: 1,
              //   color: Colors.black12,
              // ),
              Expanded(
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.07,
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
                            child:RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: values['hasRoutines'] == true?'${values['value']}/${values['maximum']}\n':'No\n',
                                  style: Theme.of(context).primaryTextTheme.displaySmall,
                                  children: <TextSpan>[
                                    TextSpan(text: values['hasRoutines'] == true?dailyCheckin.unit:'routines',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                                    )
                                  ]
                              ),
                            ),
                          ),
                        ),
                      ],
                      pointers: <GaugePointer>[
                        RangePointer(
                          enableAnimation: true,
                          value: values['value']!.toDouble(),
                          sizeUnit: GaugeSizeUnit.logicalPixel,
                          pointerOffset: -2,
                          color: dailyCheckin.color,
                          // gradient: SweepGradient(
                          //     colors: colorsGradient,
                          //     // stops: <double>[0.25, 0.75]
                          // ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              routineName == null
                  ? Container(
                height: height * 0.04,
                width: width * 0.25,
                decoration: BoxDecoration(
                    // color: Colors.black26,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        await dailyCheckinProvider.removeDailyCheckinProgressToFirebase(
                            dailyCheckin.step!, dailyCheckin.name!, userProvider.user!.email!);
                      },
                      child: Container(
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        height: height * 0.04,
                        width: width * 0.12,
                      ),
                    ),
                    Container(
                      height: height * 0.02,
                      width: width * 0.005,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    InkWell(
                      onTap: () async {
                        await dailyCheckinProvider.addDailyCheckinProgressToFirebase(
                            dailyCheckin.step!, dailyCheckin.name!, userProvider.user!.email!);
                      },
                      child: Container(
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        height: height * 0.04,
                        width: width * 0.12,
                      ),
                    ),
                  ],
                ),
              )
                  : Container(
                child: Text(
                  values['hasRoutines'] == true?'You can do it':'Add new routine',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                height: height * 0.04,
              ),
            ],
          );
        },
      ),
    );
  }
}
