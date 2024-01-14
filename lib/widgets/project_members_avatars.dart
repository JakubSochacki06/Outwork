import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/project.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ProjectMembersAvatars extends StatelessWidget {
  final double avatarSize;
  final Project project;
  final bool progressVisible;
  final bool addMemberVisible;

  ProjectMembersAvatars(
      {required this.avatarSize,
      required this.project,
      required this.progressVisible,
      required this.addMemberVisible});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> imageURLs = [];
    project.membersData!.forEach((FirebaseUser userData){
      imageURLs.add(userData.photoURL!);
    });
    void showProjectID() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add new member',
                style: Theme.of(context).primaryTextTheme.headlineMedium),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Project id: ',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                      children: [
                        TextSpan(
                            text: project.id,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))
                      ]),
                ),
                Text(
                  'Show this code to your friends and work together on this amazing project!',
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                )
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }


    List<Widget> generateRowChildren() {
      List<Widget> rowChildren = List.generate(imageURLs.length, (index) {
        print(index);
        return Transform.translate(
          offset: Offset(index * -15.0, 0.0),
          child: CircleAvatar(
            radius: avatarSize,
            backgroundImage: NetworkImage(imageURLs[index]),
          ),
        );
      });
      if (addMemberVisible) {
        rowChildren.add(Transform.translate(
          offset: Offset(imageURLs.length * -15.0, 0.0),
          child: CircleAvatar(
            radius: avatarSize,
            child: IconButton(
              onPressed: showProjectID,
              icon: Icon(Icons.add),
            ),
          ),
        ));
      }
      if (progressVisible) {
        rowChildren.add(Spacer());
        rowChildren.add(
          CircularPercentIndicator(
            animateFromLastPercent: true,
            percent: project.countTaskDonePercent(),
            center: Text(
              '${project.countTaskDonePercentText()}%',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            animation: true,
            progressColor: project.color,
            radius: height * 0.04,
          ),
        );
      }
      return rowChildren;
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: generateRowChildren());
  }
}
