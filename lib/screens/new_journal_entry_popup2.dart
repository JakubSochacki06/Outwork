import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/image_input.dart';
import 'package:outwork/widgets/rotating_text_journal.dart';
import 'package:provider/provider.dart';
class NewJournalEntryPopup2 extends StatefulWidget {
  final JournalEntry subject;
  NewJournalEntryPopup2({required this.subject});

  @override
  State<NewJournalEntryPopup2> createState() => _NewJournalEntryPopupState();
}

class _NewJournalEntryPopupState extends State<NewJournalEntryPopup2> {
  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if(widget.subject == journalEntryProvider.existingEntry && widget.subject.noteTitle != null){
      _titleController.text = journalEntryProvider.existingEntry.noteTitle!;
      _descriptionController.text = journalEntryProvider.existingEntry.noteDescription!;
    }
    // print('DATE IMAGE INPUT');
    // print(subject.date);
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
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
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          RotatingTextJournal(),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            // TODO: MAKE IT RESPONSIVCE
            height: 125,
            child: TextField(
              maxLines: null,
              expands: true,
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          ImageInput(subject: widget.subject,),
          SizedBox(
            height: height*0.03,
          ),
          ElevatedButton(
            onPressed: () async{
              if(widget.subject != journalEntryProvider.existingEntry){
                journalEntryProvider.journalEntry.noteDescription = _descriptionController.text;
                journalEntryProvider.journalEntry.noteTitle = _titleController.text;
                journalEntryProvider.setHasNote(true, widget.subject);
                journalEntryProvider.addJournalEntryToDatabase(userProvider.user!);
              } else {
                journalEntryProvider.existingEntry.noteDescription = _descriptionController.text;
                journalEntryProvider.existingEntry.noteTitle = _titleController.text;
                journalEntryProvider.setHasNote(true, widget.subject);
                journalEntryProvider.editJournalEntryAndSubmit(userProvider.user!);

              }
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Submit with note',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              minimumSize: Size(width*0.8, height*0.05),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
