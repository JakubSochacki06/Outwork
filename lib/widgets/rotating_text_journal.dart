import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:outwork/text_styles.dart';

class RotatingTextJournal extends StatelessWidget {
  const RotatingTextJournal({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Write about',
          style: kRotatingText,
        ),
        SizedBox(
          width: width*0.01,
        ),
        Expanded(
          child: Container(
            height: height*0.1,
            width: width*0.25,
            child: DefaultTextStyle(
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  RotateAnimatedText(
                      'your emotions', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText
                  ),
                  RotateAnimatedText('your plans', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText('your feelings', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'insecurity you’re working to overcome', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText('your day', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText('your recent failure', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText('your thoughts', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText('your goals', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'your recent disappointment', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'something you’re grateful for', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText('recent realization', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'difficult decision you’re facing', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'skill you’re working to improve', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText('your dream', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'personal project you’re working on', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'something you’ve been struggling with', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'relationship that is important to you', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'recent change in your life', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'personal values and beliefs', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      'recent accomplishments you feel proud of', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                  RotateAnimatedText(
                      ' new experience you’ve had recently', alignment: Alignment.centerLeft, textAlign: TextAlign.start, textStyle: kRotatingText),
                ],
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
