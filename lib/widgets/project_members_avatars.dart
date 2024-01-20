import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/project.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProjectMembersAvatars extends StatelessWidget {
  final double avatarSize;
  final Project project;
  final bool progressVisible;
  final double width;
  final double spaceBetweenAvatars;
  final bool addMemberVisible;

  ProjectMembersAvatars({
    required this.avatarSize,
    required this.project,
    required this.progressVisible,
    required this.addMemberVisible,
    required this.width,
    required this.spaceBetweenAvatars,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    List<String> imageURLs = [];
    project.membersData!.forEach((FirebaseUser userData) {
      imageURLs.length == 7 ? null : imageURLs.add(userData.photoURL!);
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

    List<Widget> generateAvatars() {
      List<Widget> avatars = [];

      for (int index = 0; index < imageURLs.length; index++) {
        avatars.add(
          Positioned(
            left: index * spaceBetweenAvatars,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: avatarSize,
              backgroundImage: NetworkImage(imageURLs[index]),
            ),
          ),
        );
      }

      if (addMemberVisible) {
        avatars.add(
          Positioned(
            left: imageURLs.length * spaceBetweenAvatars, // Adjust the offset accordingly
            child: CircleAvatar(
              radius: avatarSize,
              child: IconButton(
                onPressed: showProjectID,
                icon: Icon(Icons.add),
              ),
            ),
          ),
        );
      }

      return avatars;
    }

    return Row(
      children: [
        SizedBox(
          width: width,
          height: avatarSize * 2.0,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: generateAvatars(),
          ),
        ),
        Spacer(),
        progressVisible
            ? CircularPercentIndicator(
                animateFromLastPercent: true,
                percent: project.countTaskDonePercent(),
                center: Text(
                  '${project.countTaskDonePercentText()}%',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                animation: true,
                progressColor: project.color,
                radius: height * 0.04,
              )
            : Container(),
      ],
    );
  }
}
