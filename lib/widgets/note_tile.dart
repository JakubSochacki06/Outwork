import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/progress_page/mental_health_page/pop_ups/new_journal_entry_popup.dart';

class NoteTile extends StatelessWidget {
  final JournalEntry note;

  NoteTile({required this.note});

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    Future<void> showPhoto(DateTime date) async {
      String url = await journalEntryProvider.retrievePhoto(date, userProvider.user!);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.photoYouLeft, style: Theme.of(context).textTheme.bodyMedium),
            content: Image.network(url),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.close, style: Theme.of(context).textTheme.bodySmall,),
                ),
              ),
            ],
          );
        },
      );
    }

    Future<bool?> wantToDeleteNoteAlert() async {
      bool? deleteNote = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.deleteNote),
            content: Text(AppLocalizations.of(context)!.deleteNoteConfirmation),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(AppLocalizations.of(context)!.no, style: Theme.of(context).primaryTextTheme.labelMedium,),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(AppLocalizations.of(context)!.yes, style: Theme.of(context).primaryTextTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.secondary),),
              ),
            ],
          );
        },
      );
      return deleteNote;
    }
    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
    return note.hasNote
        ? Container(
            padding: const EdgeInsets.all(15),
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
                        // blurRadius: 10,
                        offset: const Offset(3, 3),
                      )
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: width * 0.2,
                      height: height * 0.07,
                      child: Image.asset('assets/emojis/${note.feeling}.png'),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                    // SizedBox(width: width*0.02,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.getFeelingAsTitle(context),
                            style:
                                Theme.of(context).textTheme.bodyMedium),
                        Text(
                          note.getDateAsString(context, themeProvider.selectedLocale!),
                          style: Theme.of(context).primaryTextTheme.labelLarge,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width*0.03,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            child: const Icon(
                              Icons.edit,
                            ),
                            onTap: () {
                              journalEntryProvider.clearExistingNote();
                              journalEntryProvider.existingEntry.noteTitle = note.noteTitle;
                              journalEntryProvider.existingEntry.noteDescription = note.noteDescription;
                              journalEntryProvider.existingEntry.storedImage = note.storedImage;
                              journalEntryProvider.existingEntry.savedImage = note.savedImage;
                              List<dynamic> clonedEmotions = [];
                              clonedEmotions.addAll(note.emotions!);
                              journalEntryProvider.existingEntry.emotions = clonedEmotions;
                              journalEntryProvider.existingEntry.hasPhoto = note.hasPhoto;
                              journalEntryProvider.existingEntry.hasNote = note.hasNote;
                              journalEntryProvider.existingEntry.feeling = note.feeling;
                              journalEntryProvider.existingEntry.stressLevel = note.stressLevel;
                              journalEntryProvider.existingEntry.date = note.date;
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
                                        child: NewJournalEntryPopup(subject: journalEntryProvider.existingEntry,),
                                      ),
                                    ),
                              );
                            },
                          ),
                          InkWell(
                            child: const Icon(
                              Icons.delete,
                            ),
                            onTap: () async {
                              bool? wantToDelete =
                              await wantToDeleteNoteAlert();
                              if (wantToDelete == true) {
                                await xpLevelProvider.removeXpAmount(15, userProvider.user!.email!);
                                await journalEntryProvider.removeJournalEntryFromDatabase(note.date!, userProvider.user!);
                                note.hasPhoto!?await journalEntryProvider.deletePhoto(note.date!, userProvider.user!):null;
                              }
                            },
                          ),
                          InkWell(
                            child: Icon(
                              note.hasPhoto!?Icons.camera_alt:Icons.no_photography,
                            ),
                            onTap: note.hasPhoto!?() {
                              showPhoto(note.date!);
                            }:null,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    note.noteTitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    note.noteDescription!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).primaryTextTheme.labelLarge,
                  ),
                ),
              ],
            ),
          )
        :
        // Journal entry without note
        Container(
            // height: height * 0.11,
            padding: const EdgeInsets.all(15),
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
                Container(
                  width: width * 0.16,
                  height: height * 0.08,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Container(
                      height: height * 0.045,
                      // width: width*0.1,
                      child: Image.asset(
                        'assets/emojis/${note.feeling}.png',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Container(
                  width: width * 0.50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        note.getDateAsString(context, themeProvider.selectedLocale!),
                        style: Theme.of(context).primaryTextTheme.labelLarge,
                      ),
                      Text(note.getFeelingAsTitle(context),
                          style: Theme.of(context).textTheme.headlineSmall),
                      SizedBox(width: width*0.02,),
                      SizedBox(
                        height: height * 0.001,
                      ),
                      Text(
                        note.getEmotionsText(),
                        style: Theme.of(context).primaryTextTheme.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    bool? wantToDelete = await wantToDeleteNoteAlert();
                    if(wantToDelete == true){
                      await xpLevelProvider.removeXpAmount(10, userProvider.user!.email!);
                      await journalEntryProvider.removeJournalEntryFromDatabase(note.date!, userProvider.user!);
                    }
                  },
                  child: const Icon(Icons.delete),
                ),
                SizedBox(width: width*0.03,),
                GestureDetector(
                  onTap: () {
                    journalEntryProvider.clearExistingNote();
                    journalEntryProvider.existingEntry.noteTitle = note.noteTitle;
                    journalEntryProvider.existingEntry.noteDescription = note.noteDescription;
                    journalEntryProvider.existingEntry.storedImage = note.storedImage;
                    journalEntryProvider.existingEntry.savedImage = note.savedImage;
                    List<dynamic> clonedEmotions = [];
                    clonedEmotions.addAll(note.emotions!);
                    journalEntryProvider.existingEntry.emotions = clonedEmotions;
                    journalEntryProvider.existingEntry.hasPhoto = note.hasPhoto;
                    journalEntryProvider.existingEntry.hasNote = note.hasNote;
                    journalEntryProvider.existingEntry.feeling = note.feeling;
                    journalEntryProvider.existingEntry.stressLevel = note.stressLevel;
                    journalEntryProvider.existingEntry.date = note.date;
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
                              child: NewJournalEntryPopup(subject: journalEntryProvider.existingEntry,),
                            ),
                          ),
                    );
                  },
                  child: const Icon(Icons.edit),
                ),
              ],
            ),
          );
  }
}
