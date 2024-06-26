import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/string_extension.dart';
import 'package:outwork/widgets/appBars/journal_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:outwork/widgets/note_tile.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MentalHealthPage extends StatelessWidget {
  const MentalHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<int> monthsAdded = [];
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context);
    ThemeProvider themeProvider =
    Provider.of<ThemeProvider>(context);

    List<Widget> buildNoteTiles() {
      return List.generate(journalEntryProvider.journalEntries.length, (index) {
        JournalEntry currentEntry =
            journalEntryProvider.journalEntries.reversed.toList()[index];

        if (!monthsAdded.contains(currentEntry.date!.month)) {
          monthsAdded.add(currentEntry.date!.month);
          String monthName = DateFormat('MMMM', themeProvider.selectedLocale!.languageCode).format(currentEntry.date!);

          return Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: monthName.capitalize(),
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        WidgetSpan(
                          child: SizedBox(width: width * 0.02),
                        ),
                        TextSpan(
                          text: '${currentEntry.date!.year}',
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              NoteTile(
                note: currentEntry,
              ),
            ],
          );
        }
        return NoteTile(
          note: currentEntry,
        );
      });
    }

    List<Widget> noteTiles = buildNoteTiles();
    return Scaffold(
      appBar: const JournalAppBar(),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
                left: width * 0.04, right: width * 0.04, top: height * 0.02),
            child: journalEntryProvider.journalEntries.length != 0
                ? ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: height * 0.02),
                    itemCount: noteTiles.length,
                    itemBuilder: (context, index) {
                      return noteTiles[index];
                    },
                  )
                : Center(
                  child: Column(
                                children: [
                  AutoSizeText(AppLocalizations.of(context)!.noNotes, style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center, maxLines: 1,),
                  Text(AppLocalizations.of(context)!.addNewNoteTo, style: Theme.of(context).primaryTextTheme.bodyMedium, textAlign: TextAlign.center,),
                  Lottie.asset('assets/noData.json', height: height*0.3),
                                ],
                              ),
                ),),
      ),
    );
  }
}
