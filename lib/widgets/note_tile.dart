import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/string_extension.dart';
import 'package:provider/provider.dart';

class NoteTile extends StatelessWidget {
  final String? noteTitle;
  final String? noteDescription;
  final String feeling;
  final DateTime date;
  final List<dynamic> emotions;

  // final String day;
  // final String month;
  // final String year;
  // final String monthName;
  final bool hasPhoto;
  final bool hasNote;

  NoteTile(
      {this.noteTitle,
      this.noteDescription,
      required this.feeling,
      required this.date,
      required this.hasPhoto,
      required this.hasNote,
      required this.emotions});

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    Future<void> showPhoto(DateTime date) async {
      String url = await journalEntryProvider.retrievePhoto(date, userProvider.user!);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Photo you left', style: Theme.of(context).textTheme.bodyMedium),
            content: Image.network(url),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: Theme.of(context).textTheme.bodySmall,),
                ),
              ),
            ],
          );
        },
      );
    }

    Future<bool> wantToDeleteNoteAlert() async {
      bool deleteNote = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete note?'),
            content: Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No', style: Theme.of(context).primaryTextTheme.labelMedium,),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes', style: Theme.of(context).primaryTextTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.secondary),),
              ),
            ],
          );
        },
      );
      return deleteNote;
    }

    String convertFeelingToTitle() {
      switch (feeling) {
        case 'sad':
        case 'unhappy':
        case 'neutral':
        case 'happy':
          return feeling.capitalize();
      }
      return 'Very happy';
    }

    String setDate() {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
      DateTime dateFormatted = DateTime(date.year, date.month, date.day);
      String monthName = DateFormat('MMMM').format(dateFormatted);
      String minutes;
      date.minute.toString().length == 1
          ? minutes = '0${date.minute}'
          : minutes = date.minute.toString();
      if (dateFormatted == today) {
        return 'Today, ${date.hour}:$minutes';
      } else if (dateFormatted == yesterday) {
        if(convertFeelingToTitle() == 'Very happy' && hasNote != true){
          return 'Yesterday';
        }
        return 'Yesterday, ${date.hour}:$minutes';
      } else {
        return '${date.day} $monthName';
      }
    }

    String emotionsText() {
      String emotionsText = '';
      for (int i = 0; i < emotions.length; i++) {
        emotionsText += emotions[i];
        if (i + 1 != emotions.length) emotionsText += ', ';
      }
      return emotionsText;
    }


    return hasNote
        ? Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: themeProvider.isLightTheme()
                  ? Border.all(color: Color(0xFFEDEDED))
                  : null,
              // color: Color(0xFFF0F2F5),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: themeProvider.isLightTheme()
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        // blurRadius: 10,
                        offset: Offset(3, 3),
                      )
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: width * 0.2,
                      height: height * 0.07,
                      child: Image.asset('assets/emojis/${feeling}.png'),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                    // SizedBox(width: width*0.02,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(convertFeelingToTitle(),
                            style:
                                Theme.of(context).textTheme.bodyMedium),
                        Text(
                          setDate(),
                          style: Theme.of(context).primaryTextTheme.labelLarge,
                        ),
                      ],
                    ),
                    // Text('Photo: '),
                    // Icon(hasPhoto == true
                    //     ? FontAwesomeIcons.check
                    //     : FontAwesomeIcons.x),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        bool wantToDelete =
                            await wantToDeleteNoteAlert();
                        if (wantToDelete) {
                          await journalEntryProvider.removeJournalEntryFromDatabase(date, userProvider.user!);
                          await journalEntryProvider.deletePhoto(date, userProvider.user!);
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                      ),
                    ),
                    IconButton(
                      onPressed: hasPhoto?() {
                        showPhoto(date);
                      }:null,
                      icon: Icon(
                        hasPhoto?Icons.camera_alt:Icons.no_photography,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    noteTitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    noteDescription!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).primaryTextTheme.labelLarge,
                  ),
                ),
              ],
            ),
          )
        :
        // Journal entry without note
        Container(
            // height: height * 0.11,
            padding: EdgeInsets.all(15),
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
                Container(
                  width: width * 0.16,
                  height: height * 0.08,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Container(
                      height: height * 0.045,
                      // width: width*0.1,
                      child: Image.asset(
                        'assets/emojis/$feeling.png',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Container(
                  width: width * 0.50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        setDate(),
                        style: Theme.of(context).primaryTextTheme.labelLarge,
                      ),
                      Text('${convertFeelingToTitle()}',
                          style: Theme.of(context).textTheme.headlineSmall),
                      SizedBox(width: width*0.02,),
                      SizedBox(
                        height: height * 0.001,
                      ),
                      Text(
                        '${emotionsText()}',
                        style: Theme.of(context).primaryTextTheme.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    bool wantToDelete = await wantToDeleteNoteAlert();
                    if(wantToDelete){
                      await journalEntryProvider.removeJournalEntryFromDatabase(date, userProvider.user!);
                    }
                  },
                  child: Icon(Icons.delete),
                ),
                SizedBox(width: width*0.03,),
                GestureDetector(
                  onTap: () async {
                  },
                  child: Icon(Icons.edit),
                ),
              ],
            ),
          );
  }
}
