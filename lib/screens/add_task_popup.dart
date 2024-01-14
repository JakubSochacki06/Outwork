import 'package:flutter/material.dart';
import 'package:outwork/models/project.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/calendar_picker_tile.dart';
import 'package:provider/provider.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool textFieldsValid() {
    bool isValid = true;
    if (_titleController.text.isEmpty) {
      setState(() {
        titleError = 'Title can\'t be empty';
        isValid = false;
      });
    } else {
      setState(() {
        titleError = null;
      });
    }

    if (_descriptionController.text.isEmpty) {
      setState(() {
        descriptionError = 'Description can\'t be empty';
        isValid = false;
      });
    } else {
      setState(() {
        descriptionError = null;
      });
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProjectsProvider projectProvider = Provider.of<ProjectsProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.only(
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
              'Add task to project',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            TextField(
              controller: _titleController,
              maxLength: 20,
              decoration: InputDecoration(
                  errorText: titleError,
                  errorStyle: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Theme.of(context).colorScheme.error),
                  // alignLabelWithHint: true,
                  labelText: 'Title',
                  labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                  hintText: 'Enter your title here'),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              child: TextField(
                maxLines: 2,
                maxLength: 40,
                controller: _descriptionController,
                decoration: InputDecoration(
                    errorText: descriptionError,
                    errorStyle: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    hintText: 'Enter description here'),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            CalendarPickerTile(calendarSubject: projectProvider.newTask),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () async{
                if(textFieldsValid()) {
                  projectProvider.newTask.title = _titleController.text;
                  projectProvider.newTask.description = _descriptionController.text;
                  projectProvider.newTask.addedBy = userProvider.user!.email!;
                  projectProvider.newTask.completed = false;
                  await projectProvider.addTaskToDatabase(widget.project,);
                  Navigator.pop(context);
                }

              },
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
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
