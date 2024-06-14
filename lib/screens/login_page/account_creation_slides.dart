import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:outwork/screens/login_page/processing_logging_page.dart';
import 'package:outwork/services/database_service.dart';
import 'package:outwork/widgets/chat_message.dart';
import 'package:provider/provider.dart';
import 'package:outwork/constants/constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/notification_look.dart';
import 'login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountCreationSlides extends StatefulWidget {
  const AccountCreationSlides({super.key});

  @override
  State<AccountCreationSlides> createState() => _AccountCreationSlidesState();
}

class _AccountCreationSlidesState extends State<AccountCreationSlides> {
  bool toughModeSelected = false;
  Map<String, Map<String, dynamic>> habitsSelected = {};
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            titleWidget: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.welcomeTo,
                  style: Theme.of(context).primaryTextTheme.displayMedium,
                ),
                Image.asset('assets/logo_login.png'),
              ],
            ),
            body:
            AppLocalizations.of(context)!.outworkDescription,
            image: Image.asset('assets/images/login.png'),
            decoration: PageDecoration(
                imagePadding: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: height * 0.02),
                bodyTextStyle: Theme.of(context).primaryTextTheme.bodyMedium!),
          ),
          PageViewModel(
            image: Image.asset(
              toughModeSelected
                  ? 'assets/images/tough.png'
                  : 'assets/logo_login.png',
              width: width * 0.8,
            ),
            titleWidget: Column(
              children: [
                Text(AppLocalizations.of(context)!.selectMode,
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center),
                Text(
                  AppLocalizations.of(context)!.changeLater,
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onTap: () {
                        setState(() {
                          toughModeSelected = false;
                        });
                      },
                      child: Container(
                        width: width * 0.4,
                        height: height * 0.05,
                        padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          color: toughModeSelected == false
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          border: themeProvider.isLightTheme()
                              ? Border.all(color: const Color(0xFFEDEDED))
                              : null,
                          // color: Color(0xFFF0F2F5),
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          boxShadow: themeProvider.isLightTheme()
                              ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                              // blurRadius: 10,
                              offset: const Offset(3, 3),
                            )
                          ]
                              : null,
                        ),
                        child: Align(
                          child: Text(
                            AppLocalizations.of(context)!.basicMode,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                color: toughModeSelected == false
                                    ?Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer:Colors.white),
                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onTap: () {
                        setState(() {
                          toughModeSelected = true;
                        });
                      },
                      child: Container(
                        width: width * 0.4,
                        height: height * 0.05,
                        padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          color: toughModeSelected == true
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          border: themeProvider.isLightTheme()
                              ? Border.all(color: const Color(0xFFEDEDED))
                              : null,
                          // color: Color(0xFFF0F2F5),
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          boxShadow: themeProvider.isLightTheme()
                              ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                              // blurRadius: 10,
                              offset: const Offset(3, 3),
                            )
                          ]
                              : null,
                        ),
                        child: toughModeSelected
                            ? Row(
                          children: [
                            Expanded(
                                child: Lottie.asset('assets/fire.json')),
                            Align(
                              child: Text(
                                AppLocalizations.of(context)!.toughMode,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer),
                              ),
                              alignment: Alignment.bottomCenter,
                            ),
                            Expanded(
                                child: Lottie.asset('assets/fire.json')),
                          ],
                        )
                            : Align(
                          child: Text(
                              AppLocalizations.of(context)!.toughMode,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.chatWithJacob,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(AppLocalizations.of(context)!.jacobDescription,
                    style: Theme.of(context).primaryTextTheme.bodySmall),
                SizedBox(
                  height: height * 0.01,
                ),
                ChatMessage(
                    text: toughModeSelected
                        ? AppLocalizations.of(context)!.toughModeJacobExample
                        : AppLocalizations.of(context)!.basicModeJacobExample,
                    isUser: false,
                  isToughMode: toughModeSelected,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(AppLocalizations.of(context)!.receiveNotifications,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(AppLocalizations.of(context)!.neverForgetRoutine,
                    style: Theme.of(context).primaryTextTheme.bodySmall),
                SizedBox(
                  height: height * 0.01,
                ),
                NotificationLook(
                  title: AppLocalizations.of(context)!.notificationExampleTitle,
                  text: toughModeSelected
                      ? AppLocalizations.of(context)!.notificationExampleTextTough
                      : AppLocalizations.of(context)!.notificationExampleTextBasic,
                )
              ],
            ),
            decoration: PageDecoration(
                titleTextStyle: Theme.of(context).textTheme.displayMedium!,
                bodyFlex: 4,
                imageAlignment: Alignment.bottomCenter,
                bodyTextStyle: Theme.of(context).primaryTextTheme.bodyMedium!),
          ),
          PageViewModel(
            title: AppLocalizations.of(context)!.endBadHabits,
            bodyWidget: Column(
              children: [
                Text(AppLocalizations.of(context)!.selectBadHabits, style: Theme.of(context).primaryTextTheme.bodyMedium, textAlign: TextAlign.center,),
                SizedBox(height: height*0.01,),
                Container(
                  height: height*0.6,
                  child: GridView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: badHabits.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: width / (height / 2),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    itemBuilder: (context, index){
                      return InkWell(
                        splashFactory: NoSplash.splashFactory,
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onTap:(){
                          setState(() {
                            if(habitsSelected.containsKey(badHabits[index])){
                              habitsSelected.remove(badHabits[index]);
                            } else {
                              habitsSelected[badHabits[index]] = {
                                'startDate':now,
                                'longestStreak':0,
                                'description':null,
                              };
                            }
                            // habitsSelected.contains(badHabits[index])?habitsSelected.remove(badHabits[index]):habitsSelected.add(badHabits[index]);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: habitsSelected.containsKey(badHabits[index])?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary, width: 2),
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
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Expanded(child: Image.asset('assets/bad habits/${badHabits[index].toLowerCase()}.png')),
                              SizedBox(height: height*0.02,),
                              AutoSizeText(badHabits[index], style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center, maxLines: 1,)
                            ],
                          ),
                          ),
                      );
                    },
                  ),
                ),
              ],
            ),
            decoration: PageDecoration(
              titleTextStyle: Theme.of(context).textTheme.displaySmall!,
            ),
          ),
        ],
        next: Text(
          AppLocalizations.of(context)!.next,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        done: Text(
          AppLocalizations.of(context)!.done,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        back: Text(
          AppLocalizations.of(context)!.back,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        showDoneButton: true,
        showBackButton: true,
        onDone: () async{
          await FirebaseAuth.instance.currentUser!.reload();
          print(FirebaseAuth.instance.currentUser);
          DatabaseService _dbS = DatabaseService();
          if(FirebaseAuth.instance.currentUser!.photoURL!=null){
            await _dbS.setUserDataFromGoogle(FirebaseAuth.instance.currentUser!, habitsSelected, toughModeSelected);
            await Purchases.logIn(FirebaseAuth.instance.currentUser!.email!);
          } else{
            print(FirebaseAuth.instance.currentUser!.displayName);
            await _dbS.setUserDataFromEmail(FirebaseAuth.instance.currentUser!, habitsSelected, toughModeSelected);
            await Purchases.logIn(FirebaseAuth.instance.currentUser!.email!);
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProcessingLoggingPage()),
          );
          bool isAllowedToSendNotification =
          await AwesomeNotifications().isNotificationAllowed();
          if (!isAllowedToSendNotification) {
            AwesomeNotifications().requestPermissionToSendNotifications();
          }
        },
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    ));
  }
}
