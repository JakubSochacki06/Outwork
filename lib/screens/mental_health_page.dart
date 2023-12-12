import 'package:flutter/material.dart';
import 'package:outwork/screens/new_journal_entry_popup.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';

class MentalHealthPage extends StatelessWidget {
  const MentalHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color(0xFFF86E45),
          label: Text(
            'add new entry',
            // TODO: ADD STYLE
            // style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              // makes it to sit right above keyboard
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  // height: MediaQuery.of(context).viewInsets.bottom == 0 ? 350 : MediaQuery.of(context).viewInsets.bottom + 200,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: NewJournalEntryPopup(),
                ),
              ),
            );
          },
        ),
        body: Column(
          children: [
            Text('entries in diary'),
          ],
        ),
      ),
    );
  }
}
