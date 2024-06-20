import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/appBars/basic_app_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/constants.dart';
import '../../../providers/theme_provider.dart';
import '../../upgrade_your_plan_page.dart';

class ManageHabitsPage extends StatefulWidget {
  final Map<dynamic, dynamic> startingHabits;
  const ManageHabitsPage({super.key, required this.startingHabits});


  @override
  State<ManageHabitsPage> createState() => _ManageHabitsPageState();
}

class _ManageHabitsPageState extends State<ManageHabitsPage> {

  bool mapsHaveSameKeys(Map<dynamic, dynamic> map1, Map<dynamic, dynamic> map2) {
    // Check if the key sets of both maps are equal
    return map1.keys.toSet().difference(map2.keys.toSet()).isEmpty &&
        map2.keys.toSet().difference(map1.keys.toSet()).isEmpty;
  }


  @override
  Widget build(BuildContext context) {
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> badHabits = getBadHabits(context);

    String getEnglishHabitName(String habitName) {
      // Create an instance of AppLocalizations
      final localizations = AppLocalizations.of(context);

      // Map localized habit names to English habit names
      final Map<String, String> habitNamesMap = {
        localizations!.junkFood: "Junk food",
        localizations.pornography: "Pornography",
        localizations.gambling: "Gambling",
        localizations.gaming: "Gaming",
        localizations.alcohol: "Alcohol",
        localizations.overspending: "Overspending",
        localizations.partying: "Partying",
        localizations.drugs: "Drugs",
        localizations.smoking: "Smoking",
        localizations.socialMedia: "Social media",
        localizations.swearing: "swearing",
      };

      // Return the English habit name if found, else return the original habit name
      return habitNamesMap[habitName] ?? habitName;
    }

    return Scaffold(
      appBar: BasicAppBar(title: AppLocalizations.of(context)!.selectBadHabitsTitle),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: !mapsHaveSameKeys(progressProvider.badHabits,widget.startingHabits)?() async{
          await progressProvider.updateBadHabits(widget.startingHabits, userProvider.user!.email!);
          Navigator.pop(context);
        }:null,
        backgroundColor: !mapsHaveSameKeys(progressProvider.badHabits,widget.startingHabits)?Theme.of(context).colorScheme.secondary:Colors.grey,
        label: Text(
          AppLocalizations.of(context)!.submitChanges,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.04),
          child: GridView.builder(
            // physics: NeverScrollableScrollPhysics(),
            itemCount: badHabits.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: width / (height / 2),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            itemBuilder: (context, index) {
              return InkWell(
                splashFactory: NoSplash.splashFactory,
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onTap: () async{
                  if (widget.startingHabits.containsKey(badHabits[index])) {
                    setState(() {
                      widget.startingHabits.remove(badHabits[index]);
                    });
                  } else {
                    if(userProvider.user!.isPremiumUser! || widget.startingHabits.length < 2){
                      setState(() {
                        widget.startingHabits[badHabits[index]] = {
                          'description': null,
                          'longestStreak': 0,
                          'startDate': DateTime.now(),
                        };
                      });
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
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                        color:
                            widget.startingHabits.containsKey(badHabits[index])
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                        width: 2),
                    boxShadow: themeProvider.isLightTheme()
                        ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(3, 3),
                            ),
                          ]
                        : null,
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Expanded(
                          child: Image.asset(
                              'assets/bad habits/${getEnglishHabitName(badHabits[index]).toLowerCase()}.png')),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      AutoSizeText(
                        badHabits[index],
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
