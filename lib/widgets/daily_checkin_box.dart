import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:outwork/models/daily_checkin.dart';
import 'package:outwork/providers/daily_checkin_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/screens/home_page/pop_ups/add_daily_checkin_popup.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/admob_service.dart';

class DailyCheckinBox extends StatefulWidget {
  final int index;
  String? routineName;
  final bool? isMorningRoutine;

  DailyCheckinBox({
    required this.index,
    this.routineName,
    this.isMorningRoutine,
  });

  @override
  State<DailyCheckinBox> createState() => _DailyCheckinBoxState();
}

class _DailyCheckinBoxState extends State<DailyCheckinBox> {

  InterstitialAd? _fullScreenAd;
  @override
  void initState() {
    super.initState();
    _createFullScreenAD();
  }

  void _createFullScreenAD() {
    InterstitialAd.load(
      adUnitId: AdMobService.fullScreenAdUnitID!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _fullScreenAd = ad,
          onAdFailedToLoad: (LoadAdError error) {
            print(error);
            _fullScreenAd = null;
          }
      ),
    );
  }

  void _showFullScreenAd(){
    if (_fullScreenAd != null){
      _fullScreenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){
          ad.dispose();
          _createFullScreenAD();
        },
        onAdFailedToShowFullScreenContent: (ad, error){
          ad.dispose();
          _createFullScreenAD();
        },
      );
      _fullScreenAd!.show();
      _fullScreenAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {

    DailyCheckinProvider dailyCheckinProvider = Provider.of<DailyCheckinProvider>(context, listen: true);
    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
    int currentMaximum = 0;
    int currentValue = 0;
    DailyCheckin dailyCheckin = DailyCheckin();

    Map<String, dynamic> _getValues(BuildContext context) {

      bool hasRoutines = true;
      if (widget.isMorningRoutine == true) {
        final morningRoutineProvider =
        Provider.of<MorningRoutineProvider>(context, listen: true);
        dailyCheckin.name = AppLocalizations.of(context)!.morning;
        dailyCheckin.emojiName = 'morning';
        dailyCheckin.step = 1;
        dailyCheckin.unit = AppLocalizations.of(context)!.routinesUnit;
        dailyCheckin.color = Theme.of(context).colorScheme.secondary;
        morningRoutineProvider.morningRoutines.length != 0 ?
        currentValue = morningRoutineProvider.countProgress() : 0;
        currentMaximum = morningRoutineProvider.morningRoutines.length != 0
            ? morningRoutineProvider.morningRoutines.length
            : 1;
        morningRoutineProvider.morningRoutines.length == 0
            ? hasRoutines = false
            : null;
      } else if (widget.isMorningRoutine == false) {
        final nightRoutineProvider =
        Provider.of<NightRoutineProvider>(context, listen: true);
        dailyCheckin.name = AppLocalizations.of(context)!.night;
        dailyCheckin.emojiName = 'bed';
        dailyCheckin.step = 1;
        dailyCheckin.unit = AppLocalizations.of(context)!.routinesUnit;
        dailyCheckin.color = const Color(0xFFAC87C5);
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
        dailyCheckin = dailyCheckinProvider.dailyCheckins[widget.index];
        currentValue = dailyCheckinProvider.dailyCheckins[widget.index].value!;
        currentMaximum = dailyCheckinProvider.dailyCheckins[widget.index].goal!;
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: themeProvider.isLightTheme()?Border.all(color: const Color(0xFFEDEDED)):null,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: themeProvider.isLightTheme()?[
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(3, 3),
          ),
        ]:null
      ),
      height: height * 0.32,
      width: width * 0.50,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  SizedBox(width: width*0.01,),
                  Flexible(
                    child: AutoSizeText(
                      dailyCheckin.name!,
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  widget.routineName == null?IconButton(
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
                            child: AddDailyCheckinPopup(buttonText: AppLocalizations.of(context)!.edit, name: dailyCheckin.name!, unit: dailyCheckinProvider.dailyCheckins[widget.index].unit!, goal: values['maximum'].toString(), step: dailyCheckinProvider.dailyCheckins[widget.index].step.toString(), emoji: dailyCheckinProvider.dailyCheckins[widget.index].emojiName!, id: dailyCheckinProvider.dailyCheckins[widget.index].id!, mode: 1,),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.settings, color: Theme.of(context).iconTheme.color,),
                  ):IconButton(onPressed: (){}, icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary,),),
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
                  // TODO: DECIDE IF IT LOOKS GOOD OR NO
                  // enableLoadingAnimation: true,
                  axes: <RadialAxis>[
                    RadialAxis(
                      axisLineStyle: AxisLineStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                                  text: values['hasRoutines'] == true?'${values['value']}/${values['maximum']}\n':'${AppLocalizations.of(context)!.noRoutinesText}\n',
                                  style: Theme.of(context).primaryTextTheme.displaySmall,
                                  children: <TextSpan>[
                                    TextSpan(text: values['hasRoutines'] == true?dailyCheckin.unit:AppLocalizations.of(context)!.routinesUnit,
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
              widget.routineName == null
                  ? Container(
                height: height * 0.04,
                width: width * 0.25,
                decoration: BoxDecoration(
                    // color: Colors.black26,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        await dailyCheckinProvider.removeDailyCheckinProgressToFirebase(
                            dailyCheckin.step!, dailyCheckin.name!, userProvider.user!.email!, xpLevelProvider);
                        // IF USER IS FREE USER HE SEES AD IF IT ROLLS ON 0 (0 to 9 RANGE, 10%)
                        if(userProvider.user!.isPremiumUser != true){
                          Random random = Random();
                          if(random.nextInt(9) == 0){
                            _showFullScreenAd();
                          }
                        }
                      },
                      child: Container(
                        child: const Icon(
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
                            dailyCheckin.step!, dailyCheckin.name!, userProvider.user!.email!, context, xpLevelProvider);
                        // IF USER IS FREE USER HE SEES AD IF IT ROLLS ON 0 (0 to 9 RANGE, 10%)
                        if(userProvider.user!.isPremiumUser != true){
                          Random random = Random();
                          if(random.nextInt(9) == 0){
                            _showFullScreenAd();
                          }
                        }
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
                child: AutoSizeText(
                  values['hasRoutines'] == true?values['value']==values['maximum']?AppLocalizations.of(context)!.greatJob:AppLocalizations.of(context)!.youCanDoIt:AppLocalizations.of(context)!.addNewRoutine,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                  maxLines: 1,
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
