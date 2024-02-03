import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

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
                  ? Border.all(color: Color(0xFFEDEDED))
                  : null,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: themeProvider.isLightTheme()
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(3, 3),
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
                  text: TextSpan(
                      text:
                          '${mostFrequentlyFeltEmotions[0].key} is your most frequently felt emotion. ',
                      style: Theme.of(context).primaryTextTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: 'You felt it ',
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
                          text: ' times. ',
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
                  ? Border.all(color: Color(0xFFEDEDED))
                  : null,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: themeProvider.isLightTheme()
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(3, 3),
                      ),
                    ]
                  : null,
            ),
            child: Center(
                child: Text(
              'Add atleast 1 note to track your most frequently felt emotion!',
              style: Theme.of(context).primaryTextTheme.bodyMedium,
              textAlign: TextAlign.center,
            )),
          );
  }
}
