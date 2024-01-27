import 'package:flutter/material.dart';
import 'package:outwork/models/project_task.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/add_project_page.dart';
import 'package:outwork/screens/join_with_code_popup.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:outwork/widgets/projects_list.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ProjectsProvider projectsProvider = Provider.of<ProjectsProvider>(context);
    List<ProjectTask> upcomingTasks = projectsProvider.upcomingTasks();
    return Scaffold(
      appBar: MainAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label: Text('Add new project',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer)),
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
                child: AddProjectPage(mode: 'Add new',),
              ),
            ),
          );
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 0.02, left: width * 0.04, right: width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keep on grinding',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Outwork all of them.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              height: height * 0.15,
              padding: EdgeInsets.symmetric(horizontal: width*0.08, vertical: height*0.01),
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
              child: Row(
                children: [
                  Column(
                    children: [
                      Text('${DateTime.now().day}',
                          style: Theme.of(context).textTheme.displayLarge),
                      Text(
                          DateFormat('MMMM')
                              .format(DateTime.now())
                              .toString(),
                          style: Theme.of(context).textTheme.bodySmall)
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  SizedBox(width: width*0.1),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Upcoming tasks', style: Theme.of(context).textTheme.bodySmall,),
                        SizedBox(height: height*0.01,),
                        upcomingTasks.length>0?Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Container(
                                      width: width*0.02,
                                      height: height*0.05,
                                      decoration: BoxDecoration(
                                          color: upcomingTasks[index].projectColor,
                                        borderRadius: BorderRadius.circular(150)
                                      ),
                                    ),
                                    SizedBox(width: width*0.03,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(upcomingTasks[index].title!, style: Theme.of(context).textTheme.labelLarge!),
                                        Text(upcomingTasks[index].countTimeLeft(), style: Theme.of(context).primaryTextTheme.labelSmall!.copyWith(color: upcomingTasks[index].colorOfDaysLeft(context)),),
                                      ],
                                    )
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: height*0.01,);
                              },
                              itemCount: upcomingTasks.length>=5?5:upcomingTasks.length),
                        ):Text('Add new tasks to projects and track it here!', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center,),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    'Your projects',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            // height: height*0.1,
                            padding: EdgeInsets.only(
                                bottom:
                                MediaQuery.of(context).viewInsets.bottom),
                            child: JoinWithCodePopup(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                          Text('Join with code',
                              style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(child: ProjectsList())
          ],
        ),
      ),
    );
  }
}
