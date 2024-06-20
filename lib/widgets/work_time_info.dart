
import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkedTimeInfo extends StatelessWidget {
  const WorkedTimeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider =
    Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;

    String evaluateWorkStatus(int minutesWorked) {
      if (minutesWorked <= 0) {
        return localizations.workStatusMessage0;
      } else if (minutesWorked <= 10) {
        return localizations.workStatusMessage10;
      } else if (minutesWorked <= 30) {
        return localizations.workStatusMessage30;
      } else if (minutesWorked <= 50) {
        return localizations.workStatusMessage50;
      } else if (minutesWorked <= 70) {
        return localizations.workStatusMessage70;
      } else {
        return localizations.workStatusMessageMore;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.01),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: themeProvider.isLightTheme()
            ? Border.all(color: const Color(0xFFEDEDED))
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: themeProvider.isLightTheme()
            ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(3, 3),
          ),
        ]
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              evaluateWorkStatus((userProvider.user!.workedSeconds!/60).round()),
              style: Theme.of(context).primaryTextTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          Column(
            children: [
              Text(
                (userProvider.user!.workedSeconds!/60).round().toString(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary),
              ),
              Text(
                localizations.minutesWorked,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}
