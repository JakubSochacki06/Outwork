import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/project.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/calendar_picker_tile.dart';
import 'package:provider/provider.dart';

class AddProjectPage extends StatefulWidget {
  final String mode;
  final Project? projectToEdit;
  const AddProjectPage({required this.mode, this.projectToEdit});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? titleError;
  String? descriptionError;
  String? projectTypeError;
  String? dueDateError;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ProjectsProvider projectProvider =
    Provider.of<ProjectsProvider>(context, listen: true);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if(widget.mode == 'Edit existing'){
      _titleController.text = widget.projectToEdit!.title!;
      _descriptionController.text = widget.projectToEdit!.description!;
    }
    projectProvider.newProject.title != null?_titleController.text = projectProvider.newProject.title!:null;
    projectProvider.newProject.description != null?_descriptionController.text = projectProvider.newProject.description!:null;

    bool validateDueDateAndTaskType(){
      bool isValid = true;
      if(projectProvider.newProject.projectType == null){
        setState(() {
          projectTypeError = 'Select project type';
          isValid = false;
        });
      } else {
        setState(() {
          projectTypeError = null;
        });
      }
      if(projectProvider.newProject.dueDate == null){
        setState(() {
          dueDateError = 'Select due date by clicking the icon';
          isValid = false;
        });
      } else {
        setState(() {
          dueDateError = null;
        });
      }

      return isValid;
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

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.02, horizontal: width * 0.04),
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
            height: height * 0.02,
          ),
          Text(
            '${widget.mode} project',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              maxLength: 20,
              controller: _titleController,
              onChanged: (word){
                if(widget.mode != 'Edit existing'){
                  projectProvider.newProject.title = word;
                }
              },
              decoration: InputDecoration(
                  errorText: titleError,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorStyle: Theme.of(context).primaryTextTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.error),
                  // alignLabelWithHint: true,
                  labelText: 'Title',
                  labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                  hintText: 'Enter your title here'),
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
              maxLength: 50,
              maxLines: 2,
              onChanged: (word){
                if(widget.mode != 'Edit existing'){
                  projectProvider.newProject.description = word;
                }

              },
              // expands: true,
              controller: _descriptionController,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorText: descriptionError,
                  errorStyle: Theme.of(context).primaryTextTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.error),
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                  hintText: 'Enter description here'),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'Due Date',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          CalendarPickerTile(calendarSubject: widget.mode == 'Edit existing'?widget.projectToEdit:projectProvider.newProject),
          dueDateError!=null?Text(dueDateError!, style: Theme.of(context).primaryTextTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.error),):Container(),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'Project type',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async{
                  widget.mode!= 'Edit existing'? projectProvider.setNewProjectType('Basic'):await projectProvider.changeProjectType('Basic', widget.projectToEdit!);
                },
                child: Text('Basic',
                    style: widget.mode!= 'Edit existing' && projectProvider.newProject.projectType == 'Basic' || widget.mode == 'Edit existing' && widget.projectToEdit!.projectType == 'Basic'
                        ? Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)
                        : Theme.of(context).textTheme.labelMedium),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor:
                  widget.mode!= 'Edit existing' && projectProvider.newProject.projectType == 'Basic' || widget.mode == 'Edit existing' && widget.projectToEdit!.projectType == 'Basic'
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
              ElevatedButton(
                onPressed: () async{
                  widget.mode!= 'Edit existing'? projectProvider.setNewProjectType('Urgent'):await projectProvider.changeProjectType('Urgent', widget.projectToEdit!);
                },
                child: Text('Urgent',
                    style: widget.mode!= 'Edit existing' && projectProvider.newProject.projectType == 'Urgent' || widget.mode == 'Edit existing' && widget.projectToEdit!.projectType == 'Urgent'
                        ? Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)
                        : Theme.of(context).textTheme.labelMedium),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor:
                  widget.mode!= 'Edit existing' && projectProvider.newProject.projectType == 'Urgent' || widget.mode == 'Edit existing' && widget.projectToEdit!.projectType == 'Urgent'
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
              ElevatedButton(
                onPressed: () async{
                  widget.mode!= 'Edit existing'? projectProvider.setNewProjectType('Important'):await projectProvider.changeProjectType('Important', widget.projectToEdit!);
                },
                child: Text('Important',
                    style: widget.mode!= 'Edit existing' && projectProvider.newProject.projectType == 'Important' || widget.mode == 'Edit existing' && widget.projectToEdit!.projectType == 'Important'
                        ? Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)
                        : Theme.of(context).textTheme.labelMedium),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor:
                  widget.mode!= 'Edit existing' && projectProvider.newProject.projectType == 'Important' || widget.mode == 'Edit existing' && widget.projectToEdit!.projectType == 'Important'
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
            ],
          ),
          projectTypeError!=null?Text(projectTypeError!, style: Theme.of(context).primaryTextTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.error),):Container(),
          SizedBox(
            height: height * 0.01,
          ),
         ElevatedButton(
            onPressed: () async {
              if(textFieldsValid() == true && validateDueDateAndTaskType() == true){
                if(widget.mode == 'Edit existing'){
                  projectProvider.changeTitleAndDescription(_titleController.text, _descriptionController.text, widget.projectToEdit!);
                } else {
                  projectProvider.newProject.membersEmails = [userProvider.user!.email!];
                  await projectProvider.addProjectToDatabase(userProvider.user!);
                }
                Navigator.pop(context);
              }
            },
            child: Text('Submit',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer)),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              minimumSize: Size(width * 0.8, height * 0.05),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
            ),
          )
        ],
      ),
    );
  }
}