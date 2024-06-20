import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';

class EmotionsList extends StatelessWidget {
  final List<String> emotions;
  final JournalEntry subject;

  EmotionsList({required this.emotions, required this.subject});

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider diaryEntryProvider = Provider.of<JournalEntryProvider>(context);
    List<Widget> setUpButtons() {
      List<Widget> buttons = [];
      emotions.forEach((emotion) => {
            buttons.add(
              ElevatedButton(
                onPressed: () {
                  diaryEntryProvider.addEmotionToEntry(emotion, subject);
                },
                child: Text(emotion, style: subject.emotions!.contains(emotion)?Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer):Theme.of(context).textTheme.labelMedium),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: const StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor: subject.emotions!.contains(emotion)?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
            ),
          });
      return buttons;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: setUpButtons(),
        ),
      ),
    );
  }
}
