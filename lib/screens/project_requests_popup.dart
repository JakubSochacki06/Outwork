import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/project.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProjectRequestsPopup extends StatelessWidget {
  final Project project;

  ProjectRequestsPopup({required this.project});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ProjectsProvider projectsProvider = Provider.of<ProjectsProvider>(context);

    return Container(
      color: Colors.transparent,
      child: Container(
        height: height * 0.3,
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
              'Requests to join the project',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: project.requests!.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<FirebaseUser?>(
                    future:
                        FirebaseUser.getUserByMail(project.requests![index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // Check if the user is found
                        if (snapshot.hasData) {
                          FirebaseUser requestedUser = snapshot.data!;
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
                                      NetworkImage(requestedUser.photoURL!),
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                Text(requestedUser.displayName ?? '',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .labelLarge),
                                Spacer(),
                                IconButton(
                                  onPressed: userProvider.user!.email ==
                                          project.membersEmails![0]
                                      ? () {
                                    projectsProvider.addUserToProject(requestedUser, project.id!);
                                  }
                                      : () {
                                          print('sorki');
                                        },
                                  icon: Icon(Icons.done),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.close),
                                    color: Theme.of(context).colorScheme.error)
                              ],
                            ),
                          );
                        } else {
                          // Handle the case when the user is not found
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
                                Text('User not found',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .labelLarge),
                                Spacer(),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.close),
                                    color: Theme.of(context).colorScheme.error)
                              ],
                            ),
                          );
                        }
                      } else {
                        // Handle other connection states (e.g., loading)
                        return CircularProgressIndicator();
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: height * 0.01,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
