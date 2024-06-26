import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/widgets/emotions_list.dart';
import 'package:outwork/widgets/error_shake_text.dart';
import 'package:outwork/widgets/main_feelings_row.dart';
import 'package:outwork/widgets/stress_slider.dart';
import 'new_journal_entry_popup2.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewJournalEntryPopup extends StatelessWidget {
  final JournalEntry subject;

  NewJournalEntryPopup({required this.subject});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool validateInput() {
      bool isValid = true;
      if (subject.feeling == null) {
        journalEntryProvider.setFeelingError(AppLocalizations.of(context)!.selectFeelings);
        isValid = false;
      } else {
        journalEntryProvider.setFeelingError(null);
      }
      return isValid;
    }

    return Container(
      color: Colors.transparent,
      child: Container(
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
              AppLocalizations.of(context)!.howAreYouFeeling,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            MainFeelingsRow(
              subject: subject,
            ),
            journalEntryProvider.feelingError != null && subject != journalEntryProvider.existingEntry
                ? ShakeWidget(
              key: UniqueKey(),
              child: Text(
                journalEntryProvider.feelingError!,
                style: Theme.of(context)
                    .primaryTextTheme
                    .labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            )
                : Container(),
            journalEntryProvider.feelingError == null || subject == journalEntryProvider.existingEntry?SizedBox(
              height: height * 0.01,
            ):Container(),
            Text(
              AppLocalizations.of(context)!.emotionsThatYouFelt,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            // GroupButton(
            //   isRadio: false,
            //   buttons: [AppLocalizations.of(context)!.excited, AppLocalizations.of(context)!.loved, AppLocalizations.of(context)!.surprised, AppLocalizations.of(context)!.angry, AppLocalizations.of(context)!.anxious, AppLocalizations.of(context)!.lonely, AppLocalizations.of(context)!.calm, AppLocalizations.of(context)!.fascinated, AppLocalizations.of(context)!.tired, AppLocalizations.of(context)!.frustrated, AppLocalizations.of(context)!.relaxed, AppLocalizations.of(context)!.bored],
            //   buttonBuilder: (bool selected, String emotion, context){
            //     return               ElevatedButton(
            //       onPressed: (){
            //         diaryEntryProvider.addEmotionToEntry(emotion, subject);
            //       },
            //       child: Text(emotion, style: subject.emotions!.contains(emotion)?Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer):Theme.of(context).textTheme.labelMedium),
            //       style: ElevatedButton.styleFrom(
            //         // maximumSize: Size(40,20),
            //         shape: const StadiumBorder(),
            //         // fixedSize: Size(width*0.2,height*0.02),
            //         backgroundColor: subject.emotions!.contains(emotion)?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary,
            //         elevation: 0,
            //       ),
            //     );
            //   },
            // ),
            // TODO: [IMPORTANT] THINK ABOUT CHANING TO group_button or multi_select_flutter
            EmotionsList(
              emotions: [AppLocalizations.of(context)!.excited, AppLocalizations.of(context)!.loved, AppLocalizations.of(context)!.surprised],
              subject: subject,
            ),
            EmotionsList(
              emotions: [AppLocalizations.of(context)!.angry, AppLocalizations.of(context)!.anxious, AppLocalizations.of(context)!.lonely],
              subject: subject,
            ),
            EmotionsList(
              emotions: [AppLocalizations.of(context)!.calm, AppLocalizations.of(context)!.fascinated, AppLocalizations.of(context)!.tired],
              subject: subject,
            ),
            EmotionsList(
              emotions: [AppLocalizations.of(context)!.frustrated, AppLocalizations.of(context)!.relaxed, AppLocalizations.of(context)!.bored],
              subject: subject,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              AppLocalizations.of(context)!.stressLevel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Container(
                height: height * 0.07,
                width: width * 0.8,
                child: StressSlider(
                  subject: subject,
                )),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: CheckboxListTile(
                  title: Text(
                    AppLocalizations.of(context)!.leaveANote,
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  value: subject.hasNote,
                  onChanged: (checkboxValue) {
                    journalEntryProvider.setHasNote(checkboxValue!, subject);
                  }),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () async {
                if (validateInput()) {
                  if (subject.hasNote == true) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: NewJournalEntryPopup2(
                            subject: subject,
                          ),
                        ),
                      ),
                    );
                  } else {
                    if (subject != journalEntryProvider.existingEntry) {
                      await journalEntryProvider
                          .addJournalEntryToDatabase(userProvider.user!);
                      XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                      await xpLevelProvider.addXpAmount(10, userProvider.user!.email!, context);
                    } else {
                      await journalEntryProvider
                          .editJournalEntryAndSubmit(userProvider.user!);
                    }
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(
                subject.hasNote ? AppLocalizations.of(context)!.addNote : AppLocalizations.of(context)!.submit,
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
