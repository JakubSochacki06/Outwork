import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/screens/chat_page.dart';
import 'package:outwork/screens/progress_page/mental_health_page/pop_ups/new_journal_entry_popup.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/note_tile.dart';
import 'package:intl/intl.dart';

import '../../../widgets/appBars/main_app_bar.dart';

class MentalHealthPage extends StatelessWidget {
  const MentalHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<int> monthsAdded = [];
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context);

    List<Widget> buildNoteTiles() {
      return List.generate(journalEntryProvider.journalEntries.length, (index) {
        JournalEntry currentEntry =
            journalEntryProvider.journalEntries.reversed.toList()[index];

        if (!monthsAdded.contains(currentEntry.date!.month)) {
          monthsAdded.add(currentEntry.date!.month);
          String monthName = DateFormat('MMMM').format(currentEntry.date!);

          return Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: monthName,
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        WidgetSpan(
                          child: SizedBox(width: width * 0.02),
                        ),
                        TextSpan(
                          text: '${currentEntry.date!.year}',
                          style: Theme.of(context).textTheme.bodyLarge,
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
      appBar: MainAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label: Text('Add new Entry',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer)),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (context) =>
                SingleChildScrollView(
                  child: Container(
                    // height: MediaQuery.of(context).viewInsets.bottom == 0 ? 350 : MediaQuery.of(context).viewInsets.bottom + 200,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
                    child: NewJournalEntryPopup(subject: journalEntryProvider.journalEntry,),
                  ),
                ),
          );
        },
      ),
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
                    child: Text('no notes'),
                  )),
      ),
    );
  }
}
