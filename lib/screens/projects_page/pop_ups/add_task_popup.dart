import 'package:flutter/material.dart';
import 'package:outwork/models/project.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/widgets/calendar_picker_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskPopup extends StatefulWidget {
  final Project project;

  AddTaskPopup({required this.project});

  @override
  State<AddTaskPopup> createState() => _AddTaskPopupState();
}

class _AddTaskPopupState extends State<AddTaskPopup> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? titleError;
  String? descriptionError;
  String? dueDateError;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProjectsProvider projectProvider = Provider.of<ProjectsProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    bool formValid() {
      bool isValid = true;
      setState(() {

        if (projectProvider.newTask.dueDate == null) {
          dueDateError = AppLocalizations.of(context)!.dueDateError;
          isValid = false;
        } else {
          dueDateError = null;
        }
        if (_titleController.text.isEmpty) {
          titleError = AppLocalizations.of(context)!.titleError;
          isValid = false;
        } else {
          titleError = null;
        }

        if (_descriptionController.text.isEmpty) {
          descriptionError = AppLocalizations.of(context)!.descriptionError;
          isValid = false;
        } else {
          descriptionError = null;
        }
      });

      return isValid;
    }
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FractionallySizedBox(
              widthFactor: 0.15,
              alignment: Alignment.center,
              child: Container(
                height: height * 0.005,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              AppLocalizations.of(context)!.addTaskToProject,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _titleController,
                maxLength: 20,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText: titleError,
                    errorStyle: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    // alignLabelWithHint: true,
                    labelText: AppLocalizations.of(context)!.title,
                    labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    hintText: AppLocalizations.of(context)!.enterTitle),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                maxLines: 2,
                maxLength: 40,
                controller: _descriptionController,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText: descriptionError,
                    errorStyle: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    labelText: AppLocalizations.of(context)!.description,
                    alignLabelWithHint: true,
                    labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    hintText: AppLocalizations.of(context)!.enterDescription),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            CalendarPickerTile(calendarSubject: projectProvider.newTask),
            dueDateError != null
                ? Text(
              dueDateError!,
              style: Theme.of(context)
                  .primaryTextTheme
                  .labelLarge!
                  .copyWith(color: Theme.of(context).colorScheme.error),
            )
                : Container(),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () async{
                if(formValid()) {
                  projectProvider.newTask.title = _titleController.text;
                  projectProvider.newTask.description = _descriptionController.text;
                  projectProvider.newTask.addedBy = userProvider.user!.email!;
                  projectProvider.newTask.completed = false;
                  await projectProvider.addTaskToDatabase(widget.project,);
                  XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                  await xpLevelProvider.addXpAmount(10, userProvider.user!.email!, context);
                  Navigator.pop(context);
                }

              },
              child: Text(
                AppLocalizations.of(context)!.submit,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: Size(width * 0.8, height * 0.05),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
