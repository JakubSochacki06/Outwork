import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/widgets/buttons/main_feeling_button.dart';

class MainFeelingsRow extends StatelessWidget {
  final JournalEntry subject;
  const MainFeelingsRow({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MainFeelingButton(
            feeling: 'sad',
          subject: subject,
        ),
        MainFeelingButton(
          feeling: 'unhappy',
          subject: subject,
        ),
        MainFeelingButton(
          feeling: 'neutral',
          subject: subject,
        ),
        MainFeelingButton(
          feeling: 'happy',
          subject: subject,
        ),
        MainFeelingButton(
          feeling: 'veryhappy',
          subject: subject,
        ),
      ],
    );
  }
}
