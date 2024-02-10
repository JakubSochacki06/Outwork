import 'dart:math';

import 'package:flutter/material.dart';
import 'package:outwork/providers/daily_checkin_provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';

class AddDailyCheckinPopup extends StatefulWidget {
  final String name;
  final String unit;
  final String goal;
  final String step;
  final String emoji;
  final String id;
  final String buttonText;

  AddDailyCheckinPopup(
      {this.name = '',
      this.unit = '',
      this.goal = '',
      this.step = '',
      this.emoji = '',
      this.id = '',
      required this.buttonText});

  @override
  State<AddDailyCheckinPopup> createState() => _AddDailyCheckinPopupState();
}

class _AddDailyCheckinPopupState extends State<AddDailyCheckinPopup> {
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  final _stepController = TextEditingController();
  final _goalController = TextEditingController();
  String? selectedEmoji;
  String? nameErrorText;
  String? unitErrorText;
  String? stepErrorText;
  String? goalErrorText;
  String? emojiErrorText;

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _stepController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.buttonText == 'Edit existing') {
      selectedEmoji = widget.emoji;
      _nameController.text = widget.name;
      _unitController.text = widget.unit;
      _stepController.text = widget.step;
      _goalController.text = widget.goal;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DailyCheckinProvider dailyCheckinProvider =
        Provider.of<DailyCheckinProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    bool validateTextFields() {
      bool isValid = true;
      setState(() {
        if (_nameController.text.isEmpty) {
          nameErrorText = 'Name can\'t be empty';
          isValid = false;
        } else {
          nameErrorText = null;
        }
        if (_unitController.text.isEmpty) {
          unitErrorText = 'Unit can\'t be empty';
          isValid = false;
        } else {
          unitErrorText = null;
        }
        if (_stepController.text.isEmpty) {
          stepErrorText = 'Step can\'t be empty';
          isValid = false;
        } else {
          stepErrorText = null;
        }
        if (_goalController.text.isEmpty) {
          goalErrorText = 'Goal can\'t be empty';
          isValid = false;
        } else {
          goalErrorText = null;
        }
        if (selectedEmoji == null) {
          emojiErrorText = 'Select emoji';
          isValid = false;
        } else {
          emojiErrorText = null;
        }
      });
      return isValid;
    }

    Future<bool?> wantToDeleteNoteAlert(BuildContext context) async {
      bool? deleteNote = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete morning routine?', style: Theme.of(context).textTheme.bodySmall,),
            content: Text('Are you sure you want to delete this routine?', style: Theme.of(context).primaryTextTheme.bodySmall),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes', style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          );
        },
      );
      return deleteNote;
    }

    Future<void> pickEmoji() async {
      List<String> availableEmojis = [
        'running',
        'exercises',
        'meditation',
        'walking',
        'reading',
        'water',
        'laptop',
        'sun'
      ];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          List<Widget> emojiRow = List.generate(
            4,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  selectedEmoji = availableEmojis[index];
                  Navigator.pop(context);
                });
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 25,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                      'assets/emojis/dailycheckin/${availableEmojis[index]}.png'),
                ),
              ),
            ),
          );

          List<Widget> emojiRow2 = List.generate(
            4,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  selectedEmoji = availableEmojis[index + 4];
                  Navigator.pop(context);
                });
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 25,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                      'assets/emojis/dailycheckin/${availableEmojis[4 + index]}.png'),
                ),
              ),
            ),
          );

          return AlertDialog(
            title: Text(
              'Choose emoji',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: emojiRow,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: emojiRow2,
                )
              ],
            ),
          );
        },
      );
    }

    List<Color> colors = [
      Color(0xFF80BCBD),
      Color(0xFFD5F0C1),
      Color(0xFF756AB6),
      Color(0xFFAC87C5),
      Color(0xFF71C9CE),
      Color(0xFFA6E3E9),
      Color(0xFF8785A2),
      Color(0xFFFFC7C7),
      Color(0xFF95E1D3),
      Color(0xFFF38181),
      Color(0xFF424874),
      Color(0xFFDCD6F7),
      Color(0xFFA6B1E1),
      Color(0xFF0F4C75),
      Color(0xFF3282B8),
      Color(0xFFB1B2FF),
      Color(0xFFAAC4FF),
      Color(0xFF798777),
      Color(0xFFBDD2B6)
    ];

    return Container(
      color: Colors.transparent,
      child: Container(
        width: width,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.only(
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
            Row(
              children: [
                Text(
                  '${widget.buttonText} daily check-in',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Spacer(),
                widget.buttonText == 'Edit existing'?Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child:
                        IconButton(onPressed: () async{
                          bool? wantToDelete = await wantToDeleteNoteAlert(context);
                          if(wantToDelete == true){
                            await dailyCheckinProvider.deleteDailyCheckinFromFirebase(widget.id, userProvider.user!.email!);
                            XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                            await xpLevelProvider.removeXpAmount(20, userProvider.user!.email!);
                          }
                          Navigator.pop(context);
                        }, icon: Icon(Icons.delete),),):Container()
              ]
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
                controller: _nameController,
                decoration: InputDecoration(
                    errorText: nameErrorText,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorStyle: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    // alignLabelWithHint: true,
                    labelText: 'Name',
                    labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    hintText: 'Reading'),
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
                controller: _unitController,
                decoration: InputDecoration(
                    errorText: unitErrorText,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorStyle: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    // alignLabelWithHint: true,
                    labelText: 'Unit',
                    labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    hintText: 'Pages'),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      width: width * 0.15,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      decoration: BoxDecoration(
                          border: goalErrorText != null
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.error,
                                  width: 2)
                              : null,
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _goalController,
                        maxLength: 2,
                        decoration: InputDecoration(
                            counterText: '',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            errorStyle: Theme.of(context)
                                .primaryTextTheme
                                .labelLarge!
                                .copyWith(
                                    color: Theme.of(context).colorScheme.error),
                            // alignLabelWithHint: true,
                            label: Center(
                                child: Text(
                              'Goal',
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            )),
                            hintText: '20'),
                      ),
                    ),
                    // goalErrorText!=null?Text(goalErrorText!, style: Theme.of(context).primaryTextTheme.labelLarge,):Container(),
                  ],
                ),
                InkWell(
                  onTap: pickEmoji,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02, vertical: height * 0.01),
                    decoration: BoxDecoration(
                      border: emojiErrorText != null
                          ? Border.all(
                              color: Theme.of(context).colorScheme.error,
                              width: 2)
                          : null,
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: selectedEmoji == null
                        ? Text(
                            'Choose emoji',
                            style:
                                Theme.of(context).primaryTextTheme.labelLarge,
                          )
                        : CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            radius: 20,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                  'assets/emojis/dailycheckin/${selectedEmoji}.png'),
                            ),
                          ),
                  ),
                ),
                Container(
                  width: width * 0.15,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                  decoration: BoxDecoration(
                      border: stepErrorText != null
                          ? Border.all(
                              color: Theme.of(context).colorScheme.error,
                              width: 2)
                          : null,
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    controller: _stepController,
                    maxLength: 2,
                    decoration: InputDecoration(
                        counterText: '',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorStyle: Theme.of(context)
                            .primaryTextTheme
                            .labelLarge!
                            .copyWith(
                                color: Theme.of(context).colorScheme.error),
                        // alignLabelWithHint: true,
                        label: Center(
                            child: Text(
                          'Step',
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        )),
                        alignLabelWithHint: true,
                        hintText: '2'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () async {
                if (validateTextFields() == true) {
                  if (widget.buttonText != 'Edit existing') {
                    String hexColor = colors[Random().nextInt(colors.length)]
                        .value
                        .toRadixString(16)
                        .padLeft(8, '0')
                        .toUpperCase();
                    await dailyCheckinProvider.addDailyCheckinToFirebase(
                        _nameController.text,
                        _unitController.text,
                        int.parse(_goalController.text),
                        int.parse(_stepController.text),
                        hexColor,
                        userProvider.user!.email!,
                        selectedEmoji!);
                    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context ,listen: false);
                    await xpLevelProvider.addXpAmount(20, userProvider.user!.email!, context);
                  } else {
                    await dailyCheckinProvider.editDailyCheckin(
                      _nameController.text,
                      _unitController.text,
                      int.parse(_goalController.text),
                      int.parse(_stepController.text),
                      userProvider.user!.email!,
                      selectedEmoji!,
                      widget.id,
                    );
                  }

                  Navigator.pop(context);
                }
              },
              child: Text(
                '${widget.buttonText} daily check-in',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
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
      ),
    );
  }
}
