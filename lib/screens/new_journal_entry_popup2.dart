import 'package:flutter/material.dart';
import 'package:outwork/widgets/image_input.dart';
import 'package:outwork/widgets/rotating_text_journal.dart';
class NewJournalEntryPopup2 extends StatefulWidget {
  const NewJournalEntryPopup2({super.key});

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
    return Container(
      child: Column(
        children: [
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
          ImageInput(),
        ],
      ),
    );
  }
}
