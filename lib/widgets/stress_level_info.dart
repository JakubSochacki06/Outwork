import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

class StressLevelInfo extends StatelessWidget {
  const StressLevelInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Future<Map<String, dynamic>> getStressLevelInfo(int stressLevel) async {
      Response response =
      await get(Uri.parse('https://outwork.onrender.com/stressadvice/$stressLevel'));
      return jsonDecode(response.body);
    }

    return Container(
      height: height * 0.15,
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
          Column(
            children: [
              Text(
                journalEntryProvider.getAverageStressScore().toString(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: journalEntryProvider.getAverageStressScore() < 5
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.error),
              ),
              Text(
                'Stress score',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(
            width: width * 0.03,
          ),
          journalEntryProvider.getAverageStressScore().toString() != 'NaN'?FutureBuilder(
            future: getStressLevelInfo(journalEntryProvider.getAverageStressScore().round()),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if (snapshot.hasData) {
                  return Expanded(
                    child: Text(
                      '${snapshot.data!['advice']}',
                      style: Theme.of(context).primaryTextTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return Expanded(
                    child: Text('No data error', style: Theme.of(context).primaryTextTheme.bodySmall,
                      textAlign: TextAlign.center,),
                  );
                }
              } else {
                return Expanded(child: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onBackground,)));
              }
            },
          ):Expanded(
            child: Text('Add more notes to track your stress and feelings', style: Theme.of(context).primaryTextTheme.bodySmall,
              textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }
}
