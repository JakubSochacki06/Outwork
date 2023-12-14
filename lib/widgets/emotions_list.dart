import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EmotionsList extends StatelessWidget {
  final List<String> emotions;

  EmotionsList({required this.emotions});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    JournalEntryProvider diaryEntryProvider = Provider.of<JournalEntryProvider>(context);
    List<Widget> buttons = [];
    void setUpButtons() {
      emotions.forEach((emotion) => {
            buttons.add(
              ElevatedButton(
                onPressed: () {
                  diaryEntryProvider.addEmotion(emotion);
                },
                child: Text(emotion, style: diaryEntryProvider.journalEntry.emotions.contains(emotion)?kEmotionActive:kEmotionInactive),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor: diaryEntryProvider.journalEntry.emotions.contains(emotion)?Color(0xFF27B5BE):Colors.black12,
                  elevation: 0,
                ),
              ),
            ),
          });
    }

    setUpButtons();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
    );
  }
}
