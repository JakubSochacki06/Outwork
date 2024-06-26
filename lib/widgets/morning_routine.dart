import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:outwork/models/routine.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/screens/home_page/pop_ups/add_morning_routine_popup.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/admob_service.dart';

class MorningRoutine extends StatefulWidget {
  const MorningRoutine({super.key});

  @override
  State<MorningRoutine> createState() => _MorningRoutineState();
}

class _MorningRoutineState extends State<MorningRoutine> {

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
    Future<bool?> wantToDeleteNoteAlert(BuildContext context) async {
      bool? deleteNote = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.deleteMorningRoutine,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            content: Text(AppLocalizations.of(context)!.deleteRoutineConfirm,
                style: Theme.of(context).primaryTextTheme.bodySmall),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(AppLocalizations.of(context)!.no, style: Theme.of(context).textTheme.bodySmall),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(AppLocalizations.of(context)!.yes,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
            ],
          );
        },
      );
      return deleteNote;
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context, listen: false);
    MorningRoutineProvider morningRoutineProvider = Provider.of<MorningRoutineProvider>(context);
    List<Routine> morningRoutines = morningRoutineProvider.morningRoutines;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: morningRoutines.length != 0 ? null : height * 0.16,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: themeProvider.isLightTheme()
              ? Border.all(color: const Color(0xFFEDEDED))
              : null,
          // color: Color(0xFFF0F2F5),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: themeProvider.isLightTheme()
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(3, 3),
                  )
                ]
              : null),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                radius: 20,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    'assets/emojis/dailycheckin/morning.png',
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.025,
              ),
              Text(
                AppLocalizations.of(context)!.morningRoutine,
                style: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
              const Spacer(),
              IconButton(
                  onPressed: () async{
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          // height: height*0.1,
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: const AddMorningRoutinePopup(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 35,
                  ))
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Divider(
            height: 1,
            thickness: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          morningRoutines.length != 0
              ? ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  itemBuilder: (context, index) {
                  String minutes = morningRoutines[index].scheduledTime!['minute'].toString().length == 1? '0${morningRoutines[index].scheduledTime!['minute']}':morningRoutines[index].scheduledTime!['minute'].toString();
                    bool isCompleted = morningRoutines[index].completed!;
                    return InkWell(
                      onTap: () async {
                        isCompleted = !isCompleted;
                        await morningRoutineProvider.updateRoutineCompletionStatus(index, isCompleted, userProvider.user!.email!);
                        isCompleted?await xpLevelProvider.addXpAmount(5, userProvider.user!.email!, context):await xpLevelProvider.removeXpAmount(5, userProvider.user!.email!);
                        if(userProvider.user!.isPremiumUser != true){
                          Random random = Random();
                          if(random.nextInt(7) == 0){
                            _showFullScreenAd();
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: width*0.015),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: isCompleted!=true?morningRoutines[index].isLate()?Theme.of(context).colorScheme.error:Theme.of(context).colorScheme.onPrimaryContainer:Theme.of(context).colorScheme.secondary, width: 2),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${morningRoutines[index].scheduledTime!['hour']}:$minutes | ',
                              style: Theme.of(context).primaryTextTheme.labelLarge,
                              maxLines: 1,
                            ),
                            Expanded(
                              child: AutoSizeText(
                                morningRoutines[index].name!,
                                style: Theme.of(context).primaryTextTheme.labelLarge,
                                maxLines: 1,
                              ),
                            ),
                            // Spacer(),
                            Checkbox(
                              value: isCompleted,
                              onChanged: (checkboxValue) async {
                                isCompleted = !isCompleted;
                                await morningRoutineProvider.updateRoutineCompletionStatus(index, isCompleted, userProvider.user!.email!);
                                isCompleted?await xpLevelProvider.addXpAmount(5, userProvider.user!.email!, context):await xpLevelProvider.removeXpAmount(5, userProvider.user!.email!);
                                if(userProvider.user!.isPremiumUser != true){
                                  Random random = Random();
                                  if(random.nextInt(7) == 0){
                                    _showFullScreenAd();
                                  }
                                }
                              },
                            ),
                            GestureDetector(
                              onTap: () async{
                                bool? wantToDelete = await wantToDeleteNoteAlert(context);
                                if(wantToDelete == true){
                                  await morningRoutineProvider.removeMorningRoutineFromDatabase(morningRoutines[index].id!, userProvider.user!.email!);
                                  await xpLevelProvider.removeXpAmount(10, userProvider.user!.email!);
                                }
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: height*0.01,);
                  },
                  itemCount: morningRoutines.length)
              : Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.clickPlusToAddNewRoutine,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                ),
        ],
      ),
    );
  }
}
