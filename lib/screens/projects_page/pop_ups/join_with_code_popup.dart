import 'package:flutter/material.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      color: Colors.transparent,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
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
              height: height * 0.01,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.joinWithProjectCode,
                style: Theme.of(context).textTheme.bodyMedium,
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
                maxLength: 6,
                controller: _codeController,
                decoration: InputDecoration(
                  errorText: errorMessage,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorStyle: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    // alignLabelWithHint: true,
                    labelText: AppLocalizations.of(context)!.projectCode,
                    labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    hintText: AppLocalizations.of(context)!.projectCodeHint
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
                    errorMessage = AppLocalizations.of(context)!.projectIDError;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                AppLocalizations.of(context)!.joinProject,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: Size(width * 0.8, height * 0.05),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
