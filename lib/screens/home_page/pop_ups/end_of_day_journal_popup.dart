
import 'package:flutter/material.dart';
import 'package:outwork/providers/end_of_the_day_journal_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EndOfDayJournalPopup extends StatefulWidget {
  const EndOfDayJournalPopup({Key? key});

  @override
  State<EndOfDayJournalPopup> createState() => _EndOfDayJournalPopupState();
}

class _EndOfDayJournalPopupState extends State<EndOfDayJournalPopup> {

  final _firstController = TextEditingController();
  final _secondController = TextEditingController();
  final _thirdController = TextEditingController();
  final _fourthController = TextEditingController();
  final _fifthController = TextEditingController();

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    _fifthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final endOfTheDayJournalProvider =
    Provider.of<EndOfTheDayJournalProvider>(context, listen: true);
    final userProvider =
    Provider.of<UserProvider>(context, listen: false);
    final nightRoutineProvider =
    Provider.of<NightRoutineProvider>(context, listen: true);
    Map<dynamic, dynamic> endOfTheDayJournal = endOfTheDayJournalProvider.endOfTheDayJournal;
    endOfTheDayJournal['I am grateful for']!=null?_firstController.text=endOfTheDayJournal['I am grateful for']:null;
    endOfTheDayJournal['I can work harder on']!=null?_secondController.text=endOfTheDayJournal['I can work harder on']:null;
    endOfTheDayJournal['My spiritual win was']!=null?_thirdController.text=endOfTheDayJournal['My spiritual win was']:null;
    endOfTheDayJournal['My physical win was']!=null?_fourthController.text=endOfTheDayJournal['My physical win was']:null;
    endOfTheDayJournal['The win of the day was']!=null?_fifthController.text=endOfTheDayJournal['The win of the day was']:null;


    return Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
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
            Text(
              'End of the day summary',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: CheckboxListTile(
                  title: Text(
                    'I did my best',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  value: endOfTheDayJournalProvider.endOfTheDayJournal['I did my best']==null?false:endOfTheDayJournalProvider.endOfTheDayJournal['I did my best'],
                  onChanged: (checkboxValue) {
                    endOfTheDayJournalProvider.changeFieldValue('I did my best', checkboxValue);
                  }),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: CheckboxListTile(
                  title: Text(
                    'I loved my close ones',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  value: endOfTheDayJournalProvider.endOfTheDayJournal['I loved my close ones']==null?false:endOfTheDayJournalProvider.endOfTheDayJournal['I loved my close ones'],
                  onChanged: (checkboxValue) {
                    endOfTheDayJournalProvider.changeFieldValue('I loved my close ones', checkboxValue);
                  }),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Align(
                    child: Text(
                      'I am grateful for',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(width: width * 0.015),
                  Expanded(
                    child: TextField(
                      controller: _firstController,
                      onChanged: (String word){
                        endOfTheDayJournalProvider.changeFieldValue('I am grateful for', word);
                      },
                    ),
                  ),
                ],
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'I can work harder on',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(width: width * 0.015),
                  Expanded(
                    child: TextField(
                      controller: _secondController,
                      onChanged: (String word){
                        endOfTheDayJournalProvider.changeFieldValue('I can work harder on', word);
                      },
                    ),
                  ),
                ],
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Align(
                    child: Text(
                      'My spiritual win was',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(width: width * 0.015),
                  Expanded(
                    child: TextField(
                      controller: _thirdController,
                      onChanged: (String word){
                        endOfTheDayJournalProvider.changeFieldValue('My spiritual win was', word);
                      },
                    ),
                  ),
                ],
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Align(
                    child: Text(
                      'My physical win was',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(width: width * 0.015),
                  Expanded(
                    child: TextField(
                      controller: _fourthController,
                      onChanged: (String word){
                        endOfTheDayJournalProvider.changeFieldValue('My physical win was', word);
                      },
                    ),
                  ),
                ],
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Align(
                    child: Text(
                      'The win of the day was',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(width: width * 0.015),
                  Expanded(
                    child: TextField(
                      controller: _fifthController,
                      onChanged: (String word){
                        endOfTheDayJournalProvider.changeFieldValue('The win of the day was', word);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () async {
                await endOfTheDayJournalProvider.submitEndOfTheDayJournal(userProvider.user!.email!);
                await nightRoutineProvider.updateRoutineCompletionStatus(nightRoutineProvider.nightRoutines.length-1, true, userProvider.user!.email!);
                Navigator.pop(context);
              },
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
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
