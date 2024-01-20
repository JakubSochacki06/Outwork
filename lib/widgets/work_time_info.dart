import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

class WorkedTimeInfo extends StatelessWidget {
  const WorkedTimeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider =
    Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.01),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: themeProvider.isLightTheme()
            ? Border.all(color: Color(0xFFEDEDED))
            : null,
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
      child: Row(
        children: [
          Expanded(
            child: Text(
                'I see you working hard. Head down and keep on going, your time to shine will come.',
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
                'Minutes worked',
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
