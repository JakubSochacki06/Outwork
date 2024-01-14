import 'package:flutter/material.dart';
import 'package:outwork/screens/new_journal_entry_popup.dart';

class MentalHealthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MentalHealthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: ,
      automaticallyImplyLeading: false,
      // backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              // makes it to sit right above keyboard
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
                      child: NewJournalEntryPopup(),
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
