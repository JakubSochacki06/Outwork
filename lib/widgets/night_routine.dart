import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/routine.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/screens/home_page/pop_ups/add_night_routine_popup.dart';
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
    Future<bool?> wantToDeleteNoteAlert(BuildContext context) async {
      bool? deleteNote = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete night routine?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            content: Text('Are you sure you want to delete this routine?',
                style: Theme.of(context).primaryTextTheme.bodySmall),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No', style: Theme.of(context).textTheme.bodySmall),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
            ],
          );
        },
      );
      return deleteNote;
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
    NightRoutineProvider nightRoutineProvider = Provider.of<NightRoutineProvider>(context);
    List<Routine> nightRoutines = nightRoutineProvider.nightRoutines;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: nightRoutines.length != 0 ? null : height * 0.16,
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
                    'assets/emojis/dailycheckin/bed.png',
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
                      useRootNavigator: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          // height: height*0.1,
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
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
          nightRoutines.length != 0
              ? ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String minutes = '';
                nightRoutines[index].scheduledTime != null?nightRoutines[index].scheduledTime!['minute'].toString().length == 1?minutes = '0${nightRoutines[index].scheduledTime!['minute']}': minutes = nightRoutines[index].scheduledTime!['minute'].toString():null;
                bool isCompleted = nightRoutines[index].completed!;
                return InkWell(
                  onTap: () async {

                    isCompleted = !isCompleted;
                    await nightRoutineProvider.updateRoutineCompletionStatus(index, isCompleted, userProvider.user!.email!);
                    isCompleted?await xpLevelProvider.addXpAmount(5, userProvider.user!.email!):await xpLevelProvider.removeXpAmount(5, userProvider.user!.email!);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width*0.015),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: isCompleted!=true?nightRoutines[index].isLate()?Theme.of(context).colorScheme.error:Theme.of(context).colorScheme.onPrimaryContainer:Theme.of(context).colorScheme.secondary, width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            nightRoutines[index].scheduledTime!=null?'${nightRoutines[index].scheduledTime!['hour']}:$minutes | ${nightRoutines[index].name}':nightRoutines[index].name!,
                            style: Theme.of(context).primaryTextTheme.labelLarge,
                            maxLines: 1,
                          ),
                        ),
                        // Spacer(),
                        Checkbox(
                          value: isCompleted,
                          onChanged: (checkboxValue) async {
                            isCompleted = !isCompleted;
                            await nightRoutineProvider.updateRoutineCompletionStatus(index, isCompleted, userProvider.user!.email!);
                            isCompleted?await xpLevelProvider.addXpAmount(5, userProvider.user!.email!):await xpLevelProvider.removeXpAmount(5, userProvider.user!.email!);
                          },
                        ),
                        GestureDetector(
                          onTap: () async{
                            bool? wantToDelete = await wantToDeleteNoteAlert(context);
                            if(wantToDelete == true){
                              await nightRoutineProvider.removeNightRoutineFromDatabase(nightRoutines[index].id!, userProvider.user!.email!);
                              await xpLevelProvider.removeXpAmount(10, userProvider.user!.email!);
                            }
                          },
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: height*0.01,);
              },
              itemCount: nightRoutines.length)
              : Expanded(
            child: Text(
              'Add new night routine',
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
