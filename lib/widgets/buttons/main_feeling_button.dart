import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:provider/provider.dart';

class MainFeelingButton extends StatelessWidget {
  final String feeling;
  const MainFeelingButton({required this.feeling});

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider diaryEntryProvider = Provider.of<JournalEntryProvider>(context);
    return GestureDetector(
      onTap: (){
        diaryEntryProvider.updateSelectedFeeling(feeling);
      },
      child: CircleAvatar(
        radius: 25,
        backgroundColor: diaryEntryProvider.selectedFeeling == feeling?Colors.black12:Colors.transparent,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: diaryEntryProvider.selectedFeeling == feeling?15:25,
          child: Image.asset('assets/emojis/$feeling.png'),
        ),
      ),
    );
  }
}
