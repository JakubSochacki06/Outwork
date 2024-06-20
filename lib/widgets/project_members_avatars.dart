import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/project.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            title: Text(AppLocalizations.of(context)!.addNewMember,
                style: Theme.of(context).primaryTextTheme.headlineMedium),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: AppLocalizations.of(context)!.projectID,
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
                  AppLocalizations.of(context)!.showThisCode,
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
                    AppLocalizations.of(context)!.close,
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
                icon: const Icon(Icons.add),
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
        const Spacer(),
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
