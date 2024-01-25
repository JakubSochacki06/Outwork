import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:provider/provider.dart';

class MainFeelingButton extends StatelessWidget {
  final String feeling;
  final JournalEntry subject;
  const MainFeelingButton({required this.feeling, required this.subject});

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context);
    return GestureDetector(
      onTap: (){
        journalEntryProvider.updateSelectedFeeling(feeling, subject);
        journalEntryProvider.setFeelingError(null);
      },
      child: CircleAvatar(
        radius: 25,
        backgroundColor: subject.feeling == feeling?Theme.of(context).colorScheme.onPrimaryContainer:Colors.transparent,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: subject.feeling == feeling?15:25,
          child: Image.asset('assets/emojis/$feeling.png'),
        ),
      ),
    );
  }
}
