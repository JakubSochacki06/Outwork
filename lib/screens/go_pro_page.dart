import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:outwork/screens/upgrade_your_plan_page.dart';
import 'package:outwork/widgets/premium_feature.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoProPage extends StatelessWidget {
  final Offerings offerings;
  const GoProPage({required this.offerings});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: height * 0.02, left: width * 0.04, right: width * 0.04),
                child: Column(
                  children: [
                    Lottie.asset('assets/upgrade.json'),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: AppLocalizations.of(context)!.premiumUsersAre,
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: <TextSpan>[
                            TextSpan(text: '3.7x ',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary)
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!.moreLikely,
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: height*0.01,),
                    Column(
                      children: [
                        PremiumFeature(
                            leftIcon: LineIcons.comments,
                            title: AppLocalizations.of(context)!.unlimitedChatting,
                            description: AppLocalizations.of(context)!.unlimitedChattingDescription),
                        SizedBox(height: height*0.01,),
                        PremiumFeature(
                            leftIcon: LineIcons.infinity,
                            title: AppLocalizations.of(context)!.noLimits,
                            description: AppLocalizations.of(context)!.noLimitsDescription),
                        SizedBox(height: height*0.01,),
                        PremiumFeature(
                            leftIcon: LineIcons.trophy,
                            title: AppLocalizations.of(context)!.earnTrophies,
                            description: AppLocalizations.of(context)!.earnTrophiesDescription),
                        SizedBox(height: height*0.01,),
                        PremiumFeature(
                            leftIcon: LineIcons.ban,
                            title: AppLocalizations.of(context)!.noAds,
                            description: AppLocalizations.of(context)!.noAdsDescription),
                        SizedBox(height: height*0.01,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary, width: 4)),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 15,
                      blurRadius: 25,
                      color: Colors.black,
                    )
                  ]
              ),
              padding: EdgeInsets.symmetric(
                vertical: height*0.02, horizontal: width*0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpgradeYourPlanPage(offerings: offerings,)),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.changeYourLife,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondaryContainer),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: height*0.01,),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text(AppLocalizations.of(context)!.noThanks, style: Theme.of(context).textTheme.bodyMedium,))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
