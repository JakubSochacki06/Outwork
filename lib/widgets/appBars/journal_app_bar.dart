import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/journal_entry_provider.dart';
import '../../screens/progress_page/mental_health_page/pop_ups/new_journal_entry_popup.dart';

class JournalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JournalAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context);
    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.journal, style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.navigate_before)),
        actions: [
          IconButton(
            onPressed: (){
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
            icon: const Icon(Icons.add),
          ),
        ]
    );
  }

  @override
  Size get preferredSize =>  const Size.fromHeight(kToolbarHeight);
}