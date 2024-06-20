import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          AppLocalizations.of(context)!.writeAbout,
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
                      AppLocalizations.of(context)!.rotateAnimatedTextYourEmotions, alignment: Alignment.centerLeft
                  ),
                  RotateAnimatedText(AppLocalizations.of(context)!.rotateAnimatedTextYourPlans, alignment: Alignment.centerLeft),
                  RotateAnimatedText(AppLocalizations.of(context)!.rotateAnimatedTextYourFeelings, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextInsecurityYoureWorkingToOvercome, alignment: Alignment.centerLeft),
                  RotateAnimatedText(AppLocalizations.of(context)!.rotateAnimatedTextYourDay, alignment: Alignment.centerLeft),
                  RotateAnimatedText(AppLocalizations.of(context)!.rotateAnimatedTextYourRecentFailure, alignment: Alignment.centerLeft),
                  RotateAnimatedText(AppLocalizations.of(context)!.rotateAnimatedTextYourThoughts, alignment: Alignment.centerLeft),
                  RotateAnimatedText(AppLocalizations.of(context)!.rotateAnimatedTextYourGoals, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextYourRecentDisappointment, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextSomethingYoureGratefulFor, alignment: Alignment.centerLeft),
                  RotateAnimatedText(AppLocalizations.of(context)!.rotateAnimatedTextRecentRealization, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextDifficultDecisionYoureFacing, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextSkillYoureWorkingToImprove, alignment: Alignment.centerLeft),
                  RotateAnimatedText(AppLocalizations.of(context)!.rotateAnimatedTextYourDream, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextPersonalProjectYoureWorkingOn, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextSomethingYouveBeenStrugglingWith, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextRelationshipThatIsImportantToYou, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextRecentChangeInYourLife, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextPersonalValuesAndBeliefs, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      AppLocalizations.of(context)!.rotateAnimatedTextRecentAccomplishmentsYouFeelProudOf, alignment: Alignment.centerLeft),
                  RotateAnimatedText(
                      ' ${AppLocalizations.of(context)!.rotateAnimatedTextNewExperienceYouveHadRecently}', alignment: Alignment.centerLeft),
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
