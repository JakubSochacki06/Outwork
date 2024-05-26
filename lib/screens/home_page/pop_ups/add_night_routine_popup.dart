import 'package:flutter/material.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/widgets/time_picker_tile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../services/notifications_service.dart';
import '../../upgrade_your_plan_page.dart';

class AddNightRoutinePopup extends StatefulWidget {
  const AddNightRoutinePopup({super.key});

  @override
  State<AddNightRoutinePopup> createState() => _AddNightRoutinePopupState();
}

class _AddNightRoutinePopupState extends State<AddNightRoutinePopup> {
  final _nightRoutineController = TextEditingController();
  String? errorText;
  bool scheduleHasError = false;

  @override
  void dispose() {
    _nightRoutineController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    NightRoutineProvider nightRoutineProvider = Provider.of<NightRoutineProvider>(context, listen: true);

    bool checkIfValid() {
      bool isValid = true;
      setState(() {
        if(_nightRoutineController.text.length==0){
          errorText = 'Textfield can\'t be empty';
          isValid = false;
        } else {
          errorText = null;
        }
        if(nightRoutineProvider.scheduledTime == null){
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
              'Create night routine',
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
                controller: _nightRoutineController,
                decoration: InputDecoration(
                    errorText: errorText,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorStyle: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    // alignLabelWithHint: true,
                    labelText: 'Night routine',
                    labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    hintText: 'Enter your night routine name'),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            TimePickerTile(
              subject: nightRoutineProvider,
              hasError: scheduleHasError,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () async{
                if(userProvider.user!.isPremiumUser! || nightRoutineProvider.nightRoutines.length < 3){
                  if(checkIfValid()){
                    if(nightRoutineProvider.scheduledTime!=null){
                      await createRoutineReminderNotification(nightRoutineProvider.scheduledTime!, _nightRoutineController.text, userProvider.user!.toughModeSelected!);
                    }
                    await nightRoutineProvider.addNightRoutineToDatabase(_nightRoutineController.text, userProvider.user!.email!);
                    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                    await xpLevelProvider.addXpAmount(10, userProvider.user!.email!, context);
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
                'Submit new routine',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
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
