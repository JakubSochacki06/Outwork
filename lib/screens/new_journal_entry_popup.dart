import 'package:flutter/material.dart';
import 'package:outwork/widgets/emotions_list.dart';
import 'package:outwork/widgets/main_feelings_row.dart';
import 'package:outwork/text_styles.dart';
import 'package:outwork/widgets/stress_slider.dart';
import 'new_journal_entry_popup2.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class NewJournalEntryPopup extends StatefulWidget {
  const NewJournalEntryPopup({Key? key});

  @override
  State<NewJournalEntryPopup> createState() => _NewJournalEntryPopupState();
}

class _NewJournalEntryPopupState extends State<NewJournalEntryPopup> {
  double _value = 1;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Color(0xFF757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.only(
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
                height: height*0.005,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black12,
                ),
              ),
            ),
            SizedBox(
              height: height*0.01,
            ),
            Text(
              'How are you feeling?',
              textAlign: TextAlign.center,
              style: kRegular20,
            ),
            SizedBox(
              height: height*0.01,
            ),
            MainFeelingsRow(),
            SizedBox(
              height: height*0.01,
            ),
            Text(
              'Emotions that you felt',
              textAlign: TextAlign.center,
              style: kRegular20,
            ),
            SizedBox(
              height: height*0.01,
            ),
            EmotionsList(
              emotions: ['Excited', 'Loved', 'Surprised'],
            ),
            EmotionsList(emotions: ['Angry', 'Anxious', 'Lonely']),
            EmotionsList(
              emotions: ['Calm', 'Bored', 'Tired'],
            ),
            EmotionsList(
              emotions: ['Frustrated', 'Relaxed', 'Fascinated'],
            ),
            SizedBox(
              height: height*0.01,
            ),
            Text(
              'Stress level',
              textAlign: TextAlign.center,
              style: kRegular20,
            ),
            Container(
              height: height*0.1,
                width: width*0.8,
                child: StressSlider()),
            SizedBox(
              height: height*0.01,
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: NewJournalEntryPopup2(),
                    ),
                  ),
                );
              },
              child: Text(
                'Next',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                minimumSize: Size(width*0.8, height*0.05),
                backgroundColor: Color(0xFF2A6049),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
