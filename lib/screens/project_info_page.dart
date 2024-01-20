import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/project.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/add_project_page.dart';
import 'package:outwork/screens/add_task_popup.dart';
import 'package:outwork/screens/project_requests_popup.dart';
import 'package:outwork/widgets/project_members_avatars.dart';
import 'package:outwork/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProjectInfoPage extends StatelessWidget {
  final Project project;
  ProjectInfoPage({required this.project});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ProjectsProvider projectsProvider = Provider.of<ProjectsProvider>(context);

    Color getColorBasedOnTask() {
      Color lightThemeColor = Colors.white;
      switch (project.projectType) {
        case 'Important':
          lightThemeColor = Theme.of(context).colorScheme.error;
        case 'Urgent':
          lightThemeColor = Theme.of(context).colorScheme.onError;
        case 'Basic':
          lightThemeColor = Theme.of(context).colorScheme.onPrimaryContainer;
      }
      return themeProvider.isDarkTheme()
          ? Theme.of(context).colorScheme.onPrimaryContainer
          : lightThemeColor;
    }

    Future<bool?> wantToDeleteNoteAlert(BuildContext context) async {
      bool? deleteNote = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete project?', style: Theme.of(context).textTheme.bodySmall,),
            content: Text('Are you sure you want to delete this project? You can\'t retrieve it after', style: Theme.of(context).primaryTextTheme.bodySmall),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes', style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          );
        },
      );
      return deleteNote;
    }

    void showMembers() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Project members', style: Theme.of(context).textTheme.bodyMedium),
            content: Container(
              height: project.membersData!.length>4?height*0.5:null,
              width: double.maxFinite,
              child: ListView.separated(
                itemCount: project.membersData!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.01),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                          NetworkImage(project.membersData![index].photoURL!),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Text(project.membersData![index].displayName!,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .labelLarge),
                        Spacer(),
                        userProvider.user!.email != project.membersData![index].email?IconButton(
                            onPressed: () async{
                              await projectsProvider.deleteUserFromProject(project.membersData![index], project.id!);
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                            color: Theme.of(context).colorScheme.error):Container()
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: height * 0.01,
                  );
                },
              ),
            ),
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
              top: height * 0.02, left: width * 0.04, right: width * 0.04),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          iconSize: width * 0.07,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.primary)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.navigate_before),
                        ),
                        Spacer(),
                        Badge(
                          badgeStyle: BadgeStyle(),
                          position: BadgePosition.topEnd(end: 3, top: 0),
                          badgeAnimation: BadgeAnimation.fade(),
                          badgeContent: Text(
                            project.requests!.length.toString(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => SingleChildScrollView(
                                  child: Container(
                                    // height: height*0.1,
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child:
                                        ProjectRequestsPopup(project: project),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.people),
                          ),
                        ),
                        // TODO: ADD OPTION TO LEAVE PROJECT IF YOU ARE NOT OWNER
                        userProvider.user!.email==project.membersData![0].email?Row(
                          children: [
                            SizedBox(
                              width: width * 0.015,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error,
                                  borderRadius: BorderRadius.circular(15)),
                              child: IconButton(
                                onPressed: () async {
                                  bool? wantToDelete = await wantToDeleteNoteAlert(context);
                                  if(wantToDelete == true){
                                    await projectsProvider.deleteProject(project, userProvider.user!.email!);
                                  }
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.015,
                            ),
                            InkWell(
                              onTap: (){
                                projectsProvider.editableDummyProject.title = project.title;
                                projectsProvider.editableDummyProject.description = project.description;
                                projectsProvider.editableDummyProject.dueDate = project.dueDate;
                                projectsProvider.editableDummyProject.projectType = project.projectType;
                                projectsProvider.editableDummyProject.id = project.id;
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useRootNavigator: true,
                                  builder: (context) => SingleChildScrollView(
                                    child: Container(
                                      // height: height*0.1,
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: AddProjectPage(mode: 'Edit existing'),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  border: themeProvider.isLightTheme()
                                      ? Border.all(color: Color(0xFFEDEDED))
                                      : null,
                                  // color: Color(0xFFF0F2F5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: themeProvider.isLightTheme()
                                      ? [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            // blurRadius: 10,
                                            offset: Offset(3, 3),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Text('Edit project',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ):Container(),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: getColorBasedOnTask(),
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
                                  // blurRadius: 10,
                                  offset: Offset(3, 3),
                                )
                              ]
                            : null,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: width * 0.05),
                      child: Text(
                        project.projectType!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      project.title!,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(
                                project.membersData![0].photoURL!),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Managed by',
                              style:
                                  Theme.of(context).primaryTextTheme.titleLarge,
                            ),
                            Text(
                              project.membersData![0].displayName!,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            )
                          ],
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          radius: 25,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            child: Image.asset('assets/emojis/calendar.png'),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Due Date',
                              style:
                                  Theme.of(context).primaryTextTheme.titleLarge,
                            ),
                            Text(
                              '${project.dueDate!.day} ${DateFormat('MMMM').format(project.dueDate!).toString().substring(0, 3)} ${project.dueDate!.year}',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      project.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Text('Team members ', style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                          '(${project.membersEmails!.length})',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                              color:
                              Theme.of(context).colorScheme.primary),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.list),
                          onPressed: (){
                            showMembers();
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                    ProjectMembersAvatars(
                      avatarSize: width * 0.06,
                      project: project,
                      progressVisible: true,
                      addMemberVisible: true,
                      width:width*0.7,
                      spaceBetweenAvatars: 32,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Row(
                      children: [
                        Text(
                          'Task Progress',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Text(
                          '(${project.countTaskDoneAmount()}/${project.tasks!.length})',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  // height: height*0.1,
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: AddTaskPopup(
                                    project: project,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              border: themeProvider.isLightTheme()
                                  ? Border.all(color: Color(0xFFEDEDED))
                                  : null,
                              // color: Color(0xFFF0F2F5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: themeProvider.isLightTheme()
                                  ? [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        // blurRadius: 10,
                                        offset: Offset(3, 3),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Text('Add task',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) {
                      return SizedBox(
                        height: height * 0.01,
                      );
                    } else {
                      final taskIndex = index ~/ 2;
                      return TaskTile(project: project, taskIndex: taskIndex);
                    }
                  },
                  childCount: project.tasks!.length * 2 - 1,
                  addRepaintBoundaries: false,
                  addAutomaticKeepAlives: false,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: height * 0.03), // Adjust as needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}
