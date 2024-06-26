
import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MostFeltEmotionInfo extends StatelessWidget {
  const MostFeltEmotionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<MapEntry<String, int>> mostFrequentlyFeltEmotions =
        journalEntryProvider.getMostFeltEmotions();

    return mostFrequentlyFeltEmotions.isNotEmpty
        ? Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  mostFrequentlyFeltEmotions[0].key,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text:
                          '${mostFrequentlyFeltEmotions[0].key} ${AppLocalizations.of(context)!.isYourMostFrequentlyFeltEmotion} ',
                      style: Theme.of(context).primaryTextTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.youFeltIt,
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        ),
                        TextSpan(
                            text:
                                mostFrequentlyFeltEmotions[0].value.toString(),
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodySmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                        TextSpan(
                          text: AppLocalizations.of(context)!.times,
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        ),
                        TextSpan(
                          text: journalEntryProvider.getAdviceBasedOnEmotion(
                              mostFrequentlyFeltEmotions[0].key),
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        )
                      ]),
                ),
              ],
            ))
        : Container(
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
            child: Center(
                child: Text(
                  AppLocalizations.of(context)!.addAtleast1Note,
              style: Theme.of(context).primaryTextTheme.bodyMedium,
              textAlign: TextAlign.center,
            )),
          );
  }
}
