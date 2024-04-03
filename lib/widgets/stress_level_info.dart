
import 'package:flutter/material.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class StressLevelInfo extends StatelessWidget {
  const StressLevelInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    JournalEntryProvider journalEntryProvider =
        Provider.of<JournalEntryProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Future<Map<String, dynamic>> getStressLevelInfo(int stressLevel) async {
    //   Response response =
    //   await get(Uri.parse('https://outwork.onrender.com/stressadvice/$stressLevel'));
    //   return jsonDecode(response.body);
    // }

    String getStressAdvice(int stressLevel) {
      switch (stressLevel) {
        case 0:
          return 'You\'re doing great! Keep up the positive mindset.';
        case 1:
          return 'Stay calm and take a deep breath. It\'s just a small bump.';
        case 2:
          return 'Focus on the positive aspects of your day.';
        case 3:
          return 'Take a short break and relax. You\'ve got this!';
        case 4:
          return 'Organize your tasks and prioritize. It will help reduce stress.';
        case 5:
          return 'Consider practicing mindfulness or meditation for relaxation.';
        case 6:
          return 'Connect with friends or family for emotional support.';
        case 7:
          return 'Delegate tasks if possible. Share the load.';
        case 8:
          return 'Make sure to get enough sleep. It plays a crucial role in stress management.';
        case 9:
          return 'Seek professional help or talk to a counselor if needed.';
        case 10:
          return 'It\'s okay not to be okay. Reach out for support and take care of yourself.';
        default:
          return 'Invalid stress level';
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
          journalEntryProvider.getAverageStressScore().toString() != 'NaN'
              ? Expanded(
                child: Text(
                getStressAdvice(journalEntryProvider.getAverageStressScore().round()),
                            style: Theme.of(context).primaryTextTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
              )
              : Expanded(
                  child: Text(
                    'Add more notes to track your stress and feelings',
                    style: Theme.of(context).primaryTextTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
      ),
    );
  }
}
