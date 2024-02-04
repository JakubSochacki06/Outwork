import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/screens/mental_health_page/pop_ups/new_journal_entry_popup.dart';
import 'package:provider/provider.dart';

class MentalHealthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MentalHealthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context);
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      // backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (context) =>
                  SingleChildScrollView(
                    child: Container(
                      // height: MediaQuery.of(context).viewInsets.bottom == 0 ? 350 : MediaQuery.of(context).viewInsets.bottom + 200,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery
                              .of(context)
                              .viewInsets
                              .bottom),
                      child: NewJournalEntryPopup(subject: journalEntryProvider.journalEntry,),
                    ),
                  ),
            );
          },
        ),
      ],
      title: Text('Diary', style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  @override
  Size get preferredSize =>  new Size.fromHeight(kToolbarHeight);
}
