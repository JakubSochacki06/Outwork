import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/screens/add_morning_routine_popup.dart';
import 'package:outwork/screens/add_night_routine_popup.dart';
import 'package:outwork/screens/edit_morning_routine_popup.dart';
import 'package:outwork/screens/end_of_day_journal_popup.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';

class NightRoutine extends StatefulWidget {
  const NightRoutine({super.key});

  @override
  State<NightRoutine> createState() => _NightRoutineState();
}

class _NightRoutineState extends State<NightRoutine> {
  @override
  Widget build(BuildContext context) {
    Future<bool> wantToDeleteNoteAlert(BuildContext context) async {
      bool deleteNote = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete night routine?'),
            content: Text('Are you sure you want to delete this routine?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          );
        },
      );
      return deleteNote;
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int routineNumber = 0;
    double routineItemHeight = height * 0.06;
    return Consumer<UserProvider>(builder: (_, value, child) {
      final nightRoutineProvider =
          Provider.of<NightRoutineProvider>(context, listen: true);
      int numberOfRoutines = nightRoutineProvider.nightRoutines.length;
      List<Map<String, dynamic>> nightRoutines =
          List<Map<String, dynamic>>.from(nightRoutineProvider.nightRoutines);

      double containerHeight =
          height * 0.13 + numberOfRoutines * routineItemHeight;
      ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
      return Container(
        height: containerHeight,
        width: width * 0.9,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: themeProvider.isLightTheme()
                ? Border.all(color: Color(0xFFEDEDED))
                : null,
            // color: Color(0xFFF0F2F5),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: themeProvider.isLightTheme()
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(3, 3),
                    )
                  ]
                : null),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/emojis/bed.png',
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.025,
                ),
                Text(
                  'Night Routine',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            // height: height*0.1,
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddNightRoutinePopup(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.add, size: 35))
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Divider(
              height: 1,
              thickness: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
                child: ReorderableListView(
                  physics: NeverScrollableScrollPhysics(),
              onReorder: (int oldIndex, int newIndex) async {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Map<String, dynamic> item =
                    nightRoutines.removeAt(oldIndex);
                nightRoutines.insert(newIndex, item);
                await nightRoutineProvider.updateNightRoutineOrder(
                    nightRoutines, value.user!.email!);
              },
              children: nightRoutines
                  .asMap()
                  .entries
                  .map((MapEntry<int, Map<String, dynamic>> entry) {
                routineNumber++;
                bool isCompleted = entry.value['completed'];
                return InkWell(
                  key: ValueKey(entry.key),
                  onTap: entry.value['deletable']==true?() async {
                    isCompleted = !isCompleted;
                    await nightRoutineProvider.updateRoutineCompletionStatus(
                        entry.key, isCompleted, value.user!.email!);
                  }:(){
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom:
                              MediaQuery.of(context).viewInsets.bottom),
                          child: EndOfDayJournalPopup(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: routineItemHeight,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.02,
                        ),
                        AutoSizeText(
                          '$routineNumber. ${entry.value['name']}',
                          minFontSize: 16,
                          style: Theme.of(context).primaryTextTheme.labelLarge,
                        ),
                        Spacer(),
                        Checkbox(
                          value: isCompleted,
                          onChanged: entry.value['deletable']==true?(checkboxValue) async {
                            isCompleted = !isCompleted;
                            await nightRoutineProvider
                                .updateRoutineCompletionStatus(
                                    entry.key, isCompleted, value.user!.email!);
                            // morningRoutineNotifier.notifyListeners();
                          }:(checkboxValue){},
                        ),
                        GestureDetector(
                          onTap: entry.value['deletable']==true?() async {
                            bool wantToDelete =
                                await wantToDeleteNoteAlert(context);
                            if (wantToDelete)
                              await nightRoutineProvider
                                  .removeNightRoutineFromDatabase(
                                      entry.value['name'], value.user!.email!);
                          }:(){
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: EndOfDayJournalPopup(),
                                ),
                              ),
                            );
                          },
                          child: entry.value['deletable']==true?Icon(Icons.delete):Icon(Icons.navigate_next),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      );
    });
  }
}
