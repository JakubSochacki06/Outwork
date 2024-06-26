import 'package:flutter/material.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/widgets/calendar_picker_tile.dart';
import 'package:outwork/widgets/error_shake_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../upgrade_your_plan_page.dart';

class AddProjectPopup extends StatefulWidget {
  final int mode;

  const AddProjectPopup({required this.mode});

  @override
  State<AddProjectPopup> createState() => _AddProjectPopup();
}

class _AddProjectPopup extends State<AddProjectPopup> {
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
    if (widget.mode == 1) {
      _titleController.text = projectProvider.editableDummyProject.title!;
      _descriptionController.text =
          projectProvider.editableDummyProject.description!;
    } else {
      projectProvider.newProject.title != null
          ? _titleController.text = projectProvider.newProject.title!
          : null;
      projectProvider.newProject.description != null
          ? _descriptionController.text =
              projectProvider.newProject.description!
          : null;
    }

    bool validateInput() {
      bool isValid = true;
      setState(() {
        if (widget.mode != 1 &&
            projectProvider.newProject.projectType == null) {
          projectTypeError = AppLocalizations.of(context)!.selectProjectTypeError;
          isValid = false;
        } else {
          projectTypeError = null;
        }
        if (widget.mode != 1 &&
            projectProvider.newProject.dueDate == null) {
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
            '${widget.mode==0?AppLocalizations.of(context)!.addButtonText:AppLocalizations.of(context)!.edit} ${AppLocalizations.of(context)!.project}',
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
              onChanged: (word) {
                if (widget.mode != 1) {
                  projectProvider.newProject.title = word;
                } else {
                  projectProvider.editableDummyProject.title = word;
                }
              },
              decoration: InputDecoration(
                  errorText: titleError,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
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
              maxLength: 50,
              maxLines: 2,
              onChanged: (word) {
                if (widget.mode != 1) {
                  projectProvider.newProject.description = word;
                } else {
                  projectProvider.editableDummyProject.description = word;
                }
              },
              // expands: true,
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
          Text(
            AppLocalizations.of(context)!.dueDate,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            decoration: BoxDecoration(
              border: dueDateError != null
                  ? Border.all(
                  color: Theme.of(context).colorScheme.error,
                  width: 2)
                  : null,
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: CalendarPickerTile(
                calendarSubject: widget.mode == 1
                    ? projectProvider.editableDummyProject
                    : projectProvider.newProject),
          ),
          // dueDateError != null
          //     ? Text(
          //         dueDateError!,
          //         style: Theme.of(context)
          //             .primaryTextTheme
          //             .labelLarge!
          //             .copyWith(color: Theme.of(context).colorScheme.error),
          //       )
          //     : Container(),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            AppLocalizations.of(context)!.projectType,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.mode != 1
                      ? projectProvider.setNewProjectType('Basic')
                      : projectProvider.editProjectType('Basic');
                },
                child: Text(AppLocalizations.of(context)!.basic,
                    style: widget.mode != 1 &&
                                projectProvider.newProject.projectType ==
                                    'Basic' ||
                            widget.mode == 1 &&
                                projectProvider
                                        .editableDummyProject.projectType ==
                                    'Basic'
                        ? Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer)
                        : Theme.of(context).textTheme.labelMedium),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: const StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor: widget.mode != 1 &&
                              projectProvider.newProject.projectType ==
                                  'Basic' ||
                          widget.mode == 1 &&
                              projectProvider
                                      .editableDummyProject.projectType ==
                                  'Basic'
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.mode != 1
                      ? projectProvider.setNewProjectType('Urgent')
                      : projectProvider.editProjectType('Urgent');
                },
                child: Text(AppLocalizations.of(context)!.urgent,
                    style: widget.mode != 1 &&
                                projectProvider.newProject.projectType ==
                                    'Urgent' ||
                            widget.mode == 1 &&
                                projectProvider
                                        .editableDummyProject.projectType ==
                                    'Urgent'
                        ? Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer)
                        : Theme.of(context).textTheme.labelMedium),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: const StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor: widget.mode != 1 &&
                              projectProvider.newProject.projectType ==
                                  'Urgent' ||
                          widget.mode == 1 &&
                              projectProvider
                                      .editableDummyProject.projectType ==
                                  'Urgent'
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.mode != 1
                      ? projectProvider.setNewProjectType('Important')
                      : projectProvider.editProjectType('Important');
                },
                child: Text(AppLocalizations.of(context)!.important,
                    style: widget.mode != 1 &&
                                projectProvider.newProject.projectType ==
                                    'Important' ||
                            widget.mode == 1 &&
                                projectProvider
                                        .editableDummyProject.projectType ==
                                    'Important'
                        ? Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer)
                        : Theme.of(context).textTheme.labelMedium),
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(40,20),
                  shape: const StadiumBorder(),
                  // fixedSize: Size(width*0.2,height*0.02),
                  backgroundColor: widget.mode != 1 &&
                              projectProvider.newProject.projectType ==
                                  'Important' ||
                          widget.mode == 1 &&
                              projectProvider
                                      .editableDummyProject.projectType ==
                                  'Important'
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  elevation: 0,
                ),
              ),
            ],
          ),
          projectTypeError != null
              ?ShakeWidget(key: UniqueKey(), child: Text(
            projectTypeError!,
            style: Theme.of(context)
                .primaryTextTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.error),
          ))
              : Container(),
          SizedBox(
            height: height * 0.01,
          ),
          ElevatedButton(
            onPressed: () async {
              if(userProvider.user!.isPremiumUser! || projectProvider.projectsList.length < 3){
                if (validateInput()) {
                  if (widget.mode == 1) {
                    await projectProvider.saveEditedChanges();
                  } else {
                    projectProvider.newProject.membersEmails = [
                      userProvider.user!.email!
                    ];
                    await projectProvider
                        .addProjectToDatabase(userProvider.user!);
                    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                    await xpLevelProvider.addXpAmount(20, userProvider.user!.email!, context);
                  }
                  Navigator.pop(context);
                }
              } else {
                Offerings? offerings;
                try {
                  offerings = await Purchases.getOfferings();
                } catch (e) {
                  print(e);
                }
                if (offerings != null) {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: UpgradeYourPlanPage(
                      offerings: offerings,
                    ),
                    withNavBar: false,
                  );
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.submit,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer)),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
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
