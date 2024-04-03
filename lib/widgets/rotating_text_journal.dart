import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
        Text(
          'Write about',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(
          width: width*0.01,
        ),
        Expanded(
          child: Container(
            height: height*0.1,
            width: width*0.25,
            child: DefaultTextStyle(
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.labelMedium!,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  RotateAnimatedText(
                      'your emotions', alignment: Alignment.centerLeft
                  ),
                  RotateAnimatedText('your plans', alignment: Alignment.centerLeft),
                  RotateAnimatedText('your feelings', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'insecurity you’re working to overcome', alignment: Alignment.centerLeft),
                  RotateAnimatedText('your day', alignment: Alignment.centerLeft),
                  RotateAnimatedText('your recent failure', alignment: Alignment.centerLeft),
                  RotateAnimatedText('your thoughts', alignment: Alignment.centerLeft),
                  RotateAnimatedText('your goals', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'your recent disappointment', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'something you’re grateful for', alignment: Alignment.centerLeft),
                  RotateAnimatedText('recent realization', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'difficult decision you’re facing', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'skill you’re working to improve', alignment: Alignment.centerLeft),
                  RotateAnimatedText('your dream', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'personal project you’re working on', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'something you’ve been struggling with', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'relationship that is important to you', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'recent change in your life', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'personal values and beliefs', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      'recent accomplishments you feel proud of', alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      ' new experience you’ve had recently', alignment: Alignment.centerLeft),
                ],
                onTap: () {
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
