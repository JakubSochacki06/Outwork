import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:provider/provider.dart';

class MainFeelingButton extends StatelessWidget {
  final String feeling;
  const MainFeelingButton({required this.feeling});

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context);
    return GestureDetector(
      onTap: (){
        journalEntryProvider.updateSelectedFeeling(feeling);
      },
      child: CircleAvatar(
        radius: 25,
        backgroundColor: journalEntryProvider.journalEntry.feeling == feeling?Theme.of(context).colorScheme.onPrimaryContainer:Colors.transparent,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: journalEntryProvider.journalEntry.feeling == feeling?15:25,
          child: Image.asset('assets/emojis/$feeling.png'),
        ),
      ),
    );
  }
}
