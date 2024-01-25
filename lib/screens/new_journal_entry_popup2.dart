import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
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
  String? titleError;
  String? descriptionError;

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

    bool validateTextfields(){
      bool isValid = true;
      setState(() {
        if (_titleController.text.isEmpty) {
          titleError = 'Title can\'t be empty';
          isValid = false;
        } else {
          titleError = null;
        }

        if (_descriptionController.text.isEmpty) {
          descriptionError = 'Description can\'t be empty';
          isValid = false;
        } else {
          descriptionError = null;
        }
      });
      return isValid;
    }
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              maxLength: 20,
              controller: _titleController,
              decoration: InputDecoration(
                  errorText: titleError,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorStyle: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Theme.of(context).colorScheme.error),
                  // alignLabelWithHint: true,
                  labelText: 'Title',
                  labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                  hintText: 'Enter your title here'),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              maxLength: 50,
              maxLines: 2,
              controller: _descriptionController,
              decoration: InputDecoration(
                  errorText: descriptionError,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorStyle: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Theme.of(context).colorScheme.error),
                  labelText: 'Description',
                  labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                  hintText: 'Enter your description here'
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
              if(validateTextfields()){
                if(widget.subject != journalEntryProvider.existingEntry){
                  journalEntryProvider.journalEntry.noteDescription = _descriptionController.text;
                  journalEntryProvider.journalEntry.noteTitle = _titleController.text;
                  journalEntryProvider.setHasNote(true, widget.subject);
                  journalEntryProvider.addJournalEntryToDatabase(userProvider.user!);
                  XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                  await xpLevelProvider.addXpAmount(15, userProvider.user!.email!);
                } else {
                  journalEntryProvider.existingEntry.noteDescription = _descriptionController.text;
                  journalEntryProvider.existingEntry.noteTitle = _titleController.text;
                  journalEntryProvider.setHasNote(true, widget.subject);
                  journalEntryProvider.editJournalEntryAndSubmit(userProvider.user!);
                }
                Navigator.pop(context);
                Navigator.pop(context);
              }
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
