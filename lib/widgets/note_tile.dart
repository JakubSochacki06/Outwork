import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outwork/text_styles.dart';
import 'package:outwork/string_extension.dart';

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

  NoteTile({
    this.noteTitle,
    this.noteDescription,
    required this.feeling,
    required this.date,
    required this.hasPhoto,
    required this.hasNote,
    required this.emotions
  });

  Future<bool> wantToDeleteNoteAlert(BuildContext context) async {
    bool deleteNote = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete note?'),
          content: Text('Are you sure you want to delete note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
    return deleteNote;
  }

  String setDate(){
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime dateFormatted = DateTime(date.year, date.month, date.day);
    String monthName = DateFormat('MMMM').format(dateFormatted);
    String minutes;
    date.minute.toString().length == 1? minutes = '0${date.minute}': minutes = date.minute.toString();
    if(dateFormatted == today){
      return 'Today, ${date.hour}:$minutes';
    } else if(dateFormatted == yesterday){
      return 'Yesterday, ${date.hour}:$minutes';
    } else {
      return '${date.day} $monthName';
    }
  }

  String convertFeelingToTitle(){
    switch(feeling){
      case 'sad':
      case 'unhappy':
      case 'neutral':
      case 'happy':
        return feeling.capitalize();
    }
    return 'Very happy';
  }

  String emotionsText(){
    String emotionsText = '';
    for(int i = 0;i < emotions.length;i++){
      emotionsText += emotions[i];
      if(i + 1 != emotions.length) emotionsText += ', ';
    }
    return emotionsText;
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: (){

      },
      child: hasNote?Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFEDEDED)),
            // color: Color(0xFFF0F2F5),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 3,
                // blurRadius: 10,
                offset: Offset(3, 3),
              )
            ]),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: width*0.2,
                  height: height*0.07,
                  child: Image.asset(
                      'assets/emojis/${feeling}.png'),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                // SizedBox(width: width*0.02,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Text(
                        convertFeelingToTitle(),
                          style: kBold16
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      child: Text(
                        setDate(),
                        style: kSecondary14,
                      ),
                    ),
                  ],
                ),
                // Text('Photo: '),
                // Icon(hasPhoto == true
                //     ? FontAwesomeIcons.check
                //     : FontAwesomeIcons.x),
                Spacer(),
                IconButton(
                  onPressed: () {
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black38,
                  ),
                ),
                IconButton(
                  onPressed: () async{
                    bool wantToDelete = await wantToDeleteNoteAlert(context);
                    if(wantToDelete){
                    //   WANT TO DELETE
                    }
                  },
                  icon: Icon(
                  Icons.delete,
                    color: Colors.black38,
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
                style: kBold16,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                noteDescription!,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          ],
        ),

      ):
      // Journal entry without note
      Container(
        height: height * 0.11,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFEDEDED)),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: width * 0.15,
              height: height * 0.8,
              decoration: BoxDecoration(
                color: Color(0x50D9D9D9),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Center(
                child: Container(
                  height: height*0.03,
                  // width: width*0.1,
                  child: Image.asset(
                    'assets/emojis/$feeling.png',
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width*0.05,
            ),
            Container(
              width: width*0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${convertFeelingToTitle()}', style: kBold16),
                  SizedBox(
                    height: height*0.01,
                  ),
                  Text('${emotionsText()}', style: kSecondary14, overflow: TextOverflow.ellipsis,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}