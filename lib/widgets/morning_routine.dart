import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:outwork/screens/add_morning_routine_popup.dart';
import 'package:outwork/screens/edit_morning_routine_popup.dart';
import 'package:outwork/text_styles.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double routineItemHeight = height * 0.06;
    return Consumer<UserProvider>(builder: (_, value, child) {
      final morningRoutineProvider =
          Provider.of<MorningRoutineProvider>(context, listen: true);
      int numberOfRoutines = morningRoutineProvider.morningRoutines.length;
      List<Map<String, dynamic>> morningRoutines = List<Map<String, dynamic>>.from(
          morningRoutineProvider.morningRoutines);
      double containerHeight =
          height * 0.13 + numberOfRoutines * routineItemHeight;
      return Container(
        height: containerHeight,
        width: width * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFEDEDED)),
            // color: Color(0xFFF0F2F5),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(3, 3),
              )
            ]),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFEDEDED),
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
                  style: kRegular20,
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
                    icon: Icon(Icons.add))
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Divider(
              height: 1,
              color: Color(0xFFEDEDED),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
                child: ReorderableListView(
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
                bool isCompleted = entry.value['completed'];
                print(isCompleted);
                return InkWell(
                  key: ValueKey(entry.key),
                  onTap: () async {
                    print(morningRoutineProvider.morningRoutines);
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
                          entry.value['name'],
                          minFontSize: 16,
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
                          onTap: () {},
                          child: Icon(Icons.add_a_photo),
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
