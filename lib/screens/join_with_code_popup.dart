import 'package:flutter/material.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';

class JoinWithCodePopup extends StatefulWidget {
  const JoinWithCodePopup({super.key});

  @override
  State<JoinWithCodePopup> createState() => _AddMorningRoutinePopupState();
}

class _AddMorningRoutinePopupState extends State<JoinWithCodePopup> {
  final _codeController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProjectsProvider projectsProvider = Provider.of<ProjectsProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.all(15),
      width: width * 0.9,
      child: Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'Project code',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            width: width * 0.8,
            height: height * 0.05,
            child: TextField(
              maxLength: 6,
              controller: _codeController,
              decoration: InputDecoration(
                errorText: errorMessage,
                contentPadding: EdgeInsets.only(
                  left: width * 0.02,
                  bottom: height * 0.05 / 2,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          ElevatedButton(
            onPressed: () async {
              if(! await projectsProvider.projectIDValid(_codeController.text, userProvider.user!)){
                setState(() {
                  errorMessage = 'Project ID must be valid!';
                });
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(
              'Join project',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
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
    );
  }
}
