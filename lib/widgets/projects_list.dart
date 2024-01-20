import 'package:flutter/material.dart';
import 'package:outwork/models/project.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/project_info_page.dart';
import 'package:outwork/widgets/project_members_avatars.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProjectsList extends StatelessWidget {
  const ProjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ProjectsProvider projectsProvider = Provider.of<ProjectsProvider>(context);
    return projectsProvider.projectsList.length != 0?GridView.builder(
      // physics: NeverScrollableScrollPhysics(),
      itemCount: projectsProvider.projectsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: width / (height / 1.76),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {

        Color getColorBasedOnTask() {
          Color lightThemeColor = Colors.white;
          switch (projectsProvider.projectsList[index].projectType) {
            case 'Important':
              lightThemeColor = Theme.of(context).colorScheme.error;
            case 'Urgent':
              lightThemeColor = Theme.of(context).colorScheme.onError;
            case 'Basic':
              lightThemeColor = Theme.of(context).colorScheme.onPrimaryContainer;
          }
          return themeProvider.isDarkTheme()? Theme.of(context).colorScheme.onPrimaryContainer: lightThemeColor;
        }

        return InkWell(
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: ProjectInfoPage(
                  project: projectsProvider.projectsList[index]),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: Border.all(color: projectsProvider
                  .projectsList[index].countTaskDonePercent() == 1?Theme.of(context).colorScheme.secondary:projectsProvider
                  .projectsList[index].colorOfDaysLeft(context)==Theme.of(context).colorScheme.onSurface?Theme.of(context).colorScheme.primary:projectsProvider
                  .projectsList[index].colorOfDaysLeft(context), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: themeProvider.isLightTheme()
                  ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(3, 3),
                ),
              ]
                  : null,
            ),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        projectsProvider
                            .projectsList[index].title!,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge,
                      ),
                    ),
                    SizedBox(
                      width: width*0.02,
                    ),
                    CircularPercentIndicator(
                      percent: projectsProvider
                          .projectsList[index].countTaskDonePercent(),
                      center: Text(
                        '${projectsProvider
                            .projectsList[index].countTaskDonePercentText()}%',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      animation: true,
                      progressColor: projectsProvider.projectsList[index].color,
                      radius: height * 0.04,
                    ),
                  ],
                ),
                SizedBox(height: height*0.005,),
                Container(
                  decoration: BoxDecoration(
                    color: getColorBasedOnTask(),
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
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: width * 0.03),
                  child: Text(
                    projectsProvider.projectsList[index].projectType!,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  'Team',
                  style:
                  Theme.of(context).primaryTextTheme.labelSmall,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                ProjectMembersAvatars(
                  avatarSize: width * 0.03, project: projectsProvider.projectsList[index], progressVisible: false, addMemberVisible: false, width: width*0.35, spaceBetweenAvatars: 20,),
                SizedBox(
                  height: height * 0.01,
                ),
                Align(alignment:Alignment.center, child: Text(projectsProvider
                    .projectsList[index].countTaskDonePercent() == 1?'Done ✔️':projectsProvider.projectsList[index].countTimeLeft(), style: Theme.of(context).textTheme.labelMedium!.copyWith(color: projectsProvider
                    .projectsList[index].countTaskDonePercent() == 1?Theme.of(context).colorScheme.secondary:projectsProvider.projectsList[index].colorOfDaysLeft(context))))
              ],
            ),
          ),
        );
      },
    ):Text('Add new project or join to existing one with the code. Plan and create small tasks to achieve greatness!', style: Theme.of(context).primaryTextTheme.displaySmall, textAlign: TextAlign.center,);
  }
}
