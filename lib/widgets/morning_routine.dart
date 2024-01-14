import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/screens/add_morning_routine_popup.dart';
import 'package:outwork/screens/edit_morning_routine_popup.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';

class MorningRoutine extends StatefulWidget {
  const MorningRoutine({super.key});

  @override
  State<MorningRoutine> createState() => _MorningRoutineState();
}

class _MorningRoutineState extends State<MorningRoutine> {
  @override
  Widget build(BuildContext context) {

    Future<bool> wantToDeleteNoteAlert(BuildContext context) async {
      bool deleteNote = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete morning routine?'),
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
    double routineItemHeight = height * 0.06;
    int routineNumber = 0;
    return Consumer<UserProvider>(builder: (_, value, child) {
      final morningRoutineProvider =
          Provider.of<MorningRoutineProvider>(context, listen: true);
      int numberOfRoutines = morningRoutineProvider.morningRoutines.length;
      List<Map<String, dynamic>> morningRoutines = List<Map<String, dynamic>>.from(
          morningRoutineProvider.morningRoutines);
      double containerHeight =
          height * 0.13 + numberOfRoutines * routineItemHeight;
      ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
      return Container(
        height: containerHeight,
        width: width * 0.9,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: themeProvider.isLightTheme()?Border.all(color: Color(0xFFEDEDED)):null,
            // color: Color(0xFFF0F2F5),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: themeProvider.isLightTheme()?[
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(3, 3),
              )
            ]:null),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/emojis/morning.png',
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.025,
                ),
                Text(
                  'Morning Routine',
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
                            child: AddMorningRoutinePopup(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.add, size: 35,))
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
                    morningRoutines.removeAt(oldIndex);
                morningRoutines.insert(newIndex, item);
                await morningRoutineProvider.updateMorningRoutineOrder(morningRoutines, value.user!.email!);
              },
              children: morningRoutines
                  .asMap()
                  .entries
                  .map((MapEntry<int, Map<String, dynamic>> entry) {
                routineNumber++;
                bool isCompleted = entry.value['completed'];
                return InkWell(
                  key: ValueKey(entry.key),
                  onTap: () async {
                    isCompleted = !isCompleted;
                    await morningRoutineProvider.updateRoutineCompletionStatus(
                        entry.key, isCompleted, value.user!.email!);
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
                          onChanged: (checkboxValue) async {
                            isCompleted = !isCompleted;
                            await morningRoutineProvider.updateRoutineCompletionStatus(
                                entry.key, isCompleted, value.user!.email!);
                            // morningRoutineNotifier.notifyListeners();
                          },
                        ),
                        GestureDetector(
                          onTap: () async{
                            bool wantToDelete = await wantToDeleteNoteAlert(context);
                            if(wantToDelete) await morningRoutineProvider.removeMorningRoutineFromDatabase(entry.value['name'], value.user!.email!);
                          },
                          child: Icon(Icons.delete),
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
