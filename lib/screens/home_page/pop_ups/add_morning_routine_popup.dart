import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/widgets/time_picker_tile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../services/admob_service.dart';
import '../../../services/notifications_service.dart';
import '../../upgrade_your_plan_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddMorningRoutinePopup extends StatefulWidget {
  const AddMorningRoutinePopup({super.key});

  @override
  State<AddMorningRoutinePopup> createState() => _AddMorningRoutinePopupState();
}

class _AddMorningRoutinePopupState extends State<AddMorningRoutinePopup> {
  final _morningRoutineController = TextEditingController();
  String? errorText;
  bool scheduleHasError = false;

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
  void dispose() {
    _morningRoutineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    MorningRoutineProvider morningRoutineProvider = Provider.of<MorningRoutineProvider>(context, listen: true);

    bool checkIfValid() {
      bool isValid = true;
      setState(() {
        if(_morningRoutineController.text.length==0){
          errorText = AppLocalizations.of(context)!.textFieldCantBeEmpty;
          isValid = false;
        } else {
          errorText = null;
        }
        if(morningRoutineProvider.scheduledTime == null){
          scheduleHasError = true;
          isValid = false;
        } else {
          scheduleHasError = false;
        }
      });
      return isValid;
    }

    return Container(
      color: Colors.transparent,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FractionallySizedBox(
              widthFactor: 0.15,
              alignment: Alignment.center,
              child: Container(
                height: height * 0.005,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              AppLocalizations.of(context)!.createMorningRoutine,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                // maxLength: 20,
                controller: _morningRoutineController,
                decoration: InputDecoration(
                    errorText: errorText,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorStyle: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    // alignLabelWithHint: true,
                    labelText: AppLocalizations.of(context)!.morningRoutine,
                    labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    hintText: AppLocalizations.of(context)!.addMorningRoutineHint),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            TimePickerTile(
              subject: morningRoutineProvider,
              hasError: scheduleHasError,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () async{
                if(userProvider.user!.isPremiumUser! || morningRoutineProvider.morningRoutines.length < 3){
                  if(checkIfValid()){
                    if(morningRoutineProvider.scheduledTime!=null){
                      bool isAllowedToSendNotification =
                      await AwesomeNotifications().isNotificationAllowed();
                      if (!isAllowedToSendNotification) {
                        await AwesomeNotifications().requestPermissionToSendNotifications();
                      }
                      await createRoutineReminderNotification(morningRoutineProvider.scheduledTime!, _morningRoutineController.text, userProvider.user!.toughModeSelected!, context);
                    }
                    await morningRoutineProvider.addMorningRoutineToDatabase(_morningRoutineController.text, userProvider.user!.email!);
                    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                    await xpLevelProvider.addXpAmount(10, userProvider.user!.email!, context);
                    // IF USER IS FREE USER HE SEES AD IF IT ROLLS ON 0 (0 to 4 RANGE, 20%)
                    if(userProvider.user!.isPremiumUser != true){
                      Random random = Random();
                      if(random.nextInt(5) == 0){
                        _showFullScreenAd();
                      }
                    }
                    Navigator.pop(context);
                  }
                } else {
                  Offerings? offerings;
                  try {
                    offerings = await Purchases.getOfferings();
                  } catch (e) {
                    print(e);
                  }
                  if (offerings != null) {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: UpgradeYourPlanPage(
                        offerings: offerings,
                      ),
                      withNavBar: false,
                    );
                  }
                }
              },
              child: Text(
                AppLocalizations.of(context)!.submitNewRoutine,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                minimumSize: Size(width * 0.8, height * 0.05),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
