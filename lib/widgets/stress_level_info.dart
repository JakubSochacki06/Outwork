
import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StressLevelInfo extends StatelessWidget {
  const StressLevelInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Future<Map<String, dynamic>> getStressLevelInfo(int stressLevel) async {
    //   Response response =
    //   await get(Uri.parse('https://outwork.onrender.com/stressadvice/$stressLevel'));
    //   return jsonDecode(response.body);
    // }
    final localizations = AppLocalizations.of(context)!;

    String getStressAdvice(int stressLevel) {
      switch (stressLevel) {
        case 0:
          return localizations.stressLevelMessage0;
        case 1:
          return localizations.stressLevelMessage1;
        case 2:
          return localizations.stressLevelMessage2;
        case 3:
          return localizations.stressLevelMessage3;
        case 4:
          return localizations.stressLevelMessage4;
        case 5:
          return localizations.stressLevelMessage5;
        case 6:
          return localizations.stressLevelMessage6;
        case 7:
          return localizations.stressLevelMessage7;
        case 8:
          return localizations.stressLevelMessage8;
        case 9:
          return localizations.stressLevelMessage9;
        case 10:
          return localizations.stressLevelMessage10;
        default:
          return localizations.stressLevelMessageInvalid;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.01),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: themeProvider.isLightTheme()
            ? Border.all(color: const Color(0xFFEDEDED))
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
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
      child: Row(
        children: [
          Column(
            children: [
              Text(
                journalEntryProvider.getAverageStressScore().toString(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: journalEntryProvider.getAverageStressScore() < 5
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.error),
              ),
              Text(
                localizations.stressScore,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(
            width: width * 0.03,
          ),
          journalEntryProvider.getAverageStressScore().toString() != 'NaN'
              ? Expanded(
                child: Text(
                getStressAdvice(journalEntryProvider.getAverageStressScore().round()),
                            style: Theme.of(context).primaryTextTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
              )
              : Expanded(
                  child: Text(
                    localizations.addMoreNotesToTrackYourStress,
                    style: Theme.of(context).primaryTextTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
      ),
    );
  }
}
