import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/screens/new_journal_entry_popup.dart';
import 'package:outwork/text_styles.dart';
import 'package:outwork/widgets/appBars/mental_health_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/note_tile.dart';
import 'package:intl/intl.dart';

class MentalHealthPage extends StatelessWidget {
  const MentalHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(
      child: Scaffold(
        appBar: MentalHealthAppBar(),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height*0.02),
            child: Consumer<UserProvider>(
              builder: (context, provider, child) {
                final journalEntryProvider = Provider.of<JournalEntryProvider>(
                    context, listen: true);
                journalEntryProvider.setJournalEntries(provider.user!);

                List<int> monthsAdded = [];

                List<Widget> buildNoteTiles() {
                  return List.generate(
                      journalEntryProvider.journalEntries.length, (index) {
                    JournalEntry currentEntry = journalEntryProvider
                        .journalEntries.reversed.toList()[index];
                    bool hasNote = currentEntry.hasNote;
                    bool hasPhoto = currentEntry.hasPhoto!;

                    if (!monthsAdded.contains(currentEntry.date!.month)) {
                      monthsAdded.add(currentEntry.date!.month);
                      String monthName = DateFormat('MMMM').format(
                          currentEntry.date!);

                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                  text: monthName,
                                  style: Theme.of(context).textTheme.headlineLarge,
                                  children: [
                                    WidgetSpan(
                                      child: SizedBox(width: width*0.02),
                                    ),
                                    TextSpan(text: '${currentEntry.date!.year}',
                                        style: Theme.of(context).textTheme.titleLarge,
                                    )
                                  ]
                              ),
                            ),
                          ),
                          SizedBox(height: height*0.01,),
                          buildNoteTile(currentEntry, hasNote, hasPhoto),
                        ],
                      );
                    }
                    return buildNoteTile(currentEntry, hasNote, hasPhoto);
                  });
                }

                List<Widget> noteTiles = buildNoteTiles();

                return journalEntryProvider.journalEntries.length != 0
                    ? ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(height: height * 0.03),
                  itemCount: noteTiles.length,
                  itemBuilder: (context, index) {
                    return noteTiles[index];
                  },
                )
                    : Center(
                  child: Text('no notes'),
                );
              },
            )
        ),
      ),
    );
  }
}

Widget buildNoteTile(JournalEntry currentEntry, bool hasNote, bool hasPhoto) {
  // ADD STRESS LEVEL TO NOTE TILE
  return NoteTile(
    date: currentEntry.date!,
    feeling: currentEntry.feeling!,
    hasPhoto: hasPhoto,
    emotions: currentEntry.emotions!,
    hasNote: hasNote,
    noteTitle: hasNote ? currentEntry.noteTitle : null,
    noteDescription: hasNote ? currentEntry.noteDescription : null,
  );
}