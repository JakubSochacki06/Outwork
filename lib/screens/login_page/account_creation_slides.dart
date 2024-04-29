import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:outwork/screens/login_page/processing_logging_page.dart';
import 'package:outwork/services/database_service.dart';
import 'package:outwork/widgets/chat_message.dart';
import 'package:provider/provider.dart';
import 'package:outwork/constants/constants.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/notification_look.dart';

class AccountCreationSlides extends StatefulWidget {
  const AccountCreationSlides({super.key});

  @override
  State<AccountCreationSlides> createState() => _AccountCreationSlidesState();
}

class _AccountCreationSlidesState extends State<AccountCreationSlides> {
  bool toughModeSelected = false;
  List<String> habitsSelected = [];

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
                  'Welcome to',
                  style: Theme.of(context).primaryTextTheme.displayMedium,
                ),
                Image.asset('assets/logo_login.png'),
              ],
            ),
            body:
                'Outwork is revolutionizing self-improvement industry. Create better self, be better day by day. You were born to be great, so act like it.',
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
                Text('Select Mode',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center),
                Text(
                  'You will be able to change it later.',
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
                            'Basic',
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
                                'Tough',
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
                            'Tough',
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chat with Jacob Bot',
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('Your friendly (or not) AI',
                    style: Theme.of(context).primaryTextTheme.bodySmall),
                SizedBox(
                  height: height * 0.01,
                ),
                ChatMessage(
                    text: toughModeSelected
                        ? 'Stop crying. Didn\'t you want to be great? You have to work harder.'
                        : 'Remember it\'s okay to not feel great everytime! Clear your mind and start working again <3!',
                    isUser: false,
                  isToughMode: toughModeSelected,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text('Receive notifications',
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('Never forget about your routine or tasks',
                    style: Theme.of(context).primaryTextTheme.bodySmall),
                SizedBox(
                  height: height * 0.01,
                ),
                NotificationLook(
                  title: 'Skincare routine 🚨',
                  text: toughModeSelected
                      ? 'Stop procrastinating and do it now 🤡.'
                      : 'Stay consistent and you will win!',
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
            title: 'End bad habits',
            bodyWidget: Column(
              children: [
                Text('Select what habits you would like to quit. You will be able to change it later.', style: Theme.of(context).primaryTextTheme.bodyMedium, textAlign: TextAlign.center,),
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
                            habitsSelected.contains(badHabits[index])?habitsSelected.remove(badHabits[index]):habitsSelected.add(badHabits[index]);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: habitsSelected.contains(badHabits[index])?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary, width: 2),
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
                              Text(badHabits[index], style: Theme.of(context).textTheme.bodyMedium,)
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
          'Next',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        done: Text(
          'Done',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        back: Text(
          'Back',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        showDoneButton: true,
        showBackButton: true,
        onDone: () async{
          DatabaseService _dbS = DatabaseService();
          if(FirebaseAuth.instance.currentUser!.photoURL!=null){
            await _dbS.setUserDataFromGoogle(FirebaseAuth.instance.currentUser!, habitsSelected, toughModeSelected);
          } else{
            await _dbS.setUserDataFromEmail(FirebaseAuth.instance.currentUser!, habitsSelected, toughModeSelected);
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProcessingLoggingPage()),
          );
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
