import 'package:flutter/material.dart';
import 'package:outwork/models/project.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/screens/projects_page/pomodoro_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskTile extends StatelessWidget {
  final Project project;
  final int taskIndex;
  TaskTile({required this.project, required this.taskIndex});

  @override
  Widget build(BuildContext context) {

    Future<bool?> wantToDeleteTaskAlert(BuildContext context) async {
      bool? deleteTask = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.deleteTask, style: Theme.of(context).textTheme.bodySmall,),
            content: Text(AppLocalizations.of(context)!.areYouSureYouWantToDeleteThisTask, style: Theme.of(context).primaryTextTheme.bodySmall),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(AppLocalizations.of(context)!.no, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(AppLocalizations.of(context)!.yes, style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          );
        },
      );
      return deleteTask;
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProjectsProvider projectProvider = Provider.of<ProjectsProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(color: project.tasks![taskIndex].completed!?Theme.of(context).colorScheme.secondary:project.tasks![taskIndex].colorOfDaysLeft(context)==Theme.of(context).colorScheme.onSurface?Theme.of(context).colorScheme.primary:project.tasks![taskIndex].colorOfDaysLeft(context), width: 2),
            borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.symmetric(horizontal: width * 0.04),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        // collapsedShape: RoundedRectangleBorder(
        //   side: BorderSide.none,
        // ),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        trailing: Wrap(
          spacing: -10,
          children: [
            TextButton(
              onPressed: (){
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: PomodoroPage(userProvider: userProvider,),
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Text(AppLocalizations.of(context)!.work, style: Theme.of(context).textTheme.bodySmall,),
            ),
            Checkbox(
              value: project.tasks![taskIndex].completed,
              onChanged: (checkboxValue) async{
                XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                checkboxValue == true?await xpLevelProvider.addXpAmount(5, userProvider.user!.email!, context):await xpLevelProvider.removeXpAmount(5, userProvider.user!.email!);
                await projectProvider.updateTaskCompletionStatus(project, taskIndex);
              },
            ),
          ]
        ),
        title: Text(
          project.tasks![taskIndex].title!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
        subtitle: Text(
          project.tasks![taskIndex].completed!?'${AppLocalizations.of(context)!.done} ✔️':project.tasks![taskIndex].countTimeLeft(),
          style: Theme.of(context).primaryTextTheme.labelLarge!.copyWith(color: project.tasks![taskIndex].completed!?Theme.of(context).colorScheme.secondary:project.tasks![taskIndex].colorOfDaysLeft(context)),
          textAlign: TextAlign.start,
        ),
        children: [
          Divider(
            thickness: height*0.003,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  project.tasks![taskIndex].description!,
                  style: Theme.of(context).primaryTextTheme.labelLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  onPressed: () async {
                    bool? wantToDelete = await wantToDeleteTaskAlert(context);
                    if(wantToDelete == true){
                      await projectProvider.deleteTask(taskIndex, project.id!, userProvider.user!.email!);
                      XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                      await xpLevelProvider.addXpAmount(10, userProvider.user!.email!, context);
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
          SizedBox(height: height*0.01,),
        ],
        // child: Container(
        //   padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        //   decoration: BoxDecoration(
        //       color: Theme.of(context).colorScheme.primary,
        //       borderRadius: BorderRadius.circular(15)),
        //   child: Row(
        //     children: [
        //       SizedBox(
        //         width: width * 0.02,
        //       ),
        //       Text(
        //         title,
        //         style: Theme.of(context).primaryTextTheme.labelLarge,
        //       ),
        //       Spacer(),
        //
        //       GestureDetector(
        //         onTap: () async{
        //           // bool wantToDelete = await wantToDeleteNoteAlert(context);
        //           // if(wantToDelete) await morningRoutineProvider.removeMorningRoutineFromDatabase(entry.value['name'], value.user!.email!);
        //         },
        //         child: Icon(Icons.delete),
        //       ),
        //       SizedBox(
        //         width: width * 0.02,
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
