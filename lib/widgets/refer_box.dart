import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/profile_page/refer_page.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ReferBox extends StatelessWidget {

  const ReferBox({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    void showBalance() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Keep earning!', style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.secondary),)),
            contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15)
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/balance.png', height: height*0.2,),
                RichText(
                  text: TextSpan(
                      text: 'Balance: ',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                      children: [
                        TextSpan(
                            text: '${userProvider.user!.refBalance.toString()}\$',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary))
                      ]),
                ),
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Withdraw',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: showBalance,
          child: Container(
            height: height*0.125,
            width: width*0.285,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.03, vertical: height * 0.01),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: themeProvider.isLightTheme()
                  ? Border.all(color: const Color(0xFFEDEDED))
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_balance_wallet, size: width*0.1,),
                Text('\$${userProvider.user!.refBalance}', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary), textAlign: TextAlign.left),
                AutoSizeText('Balance', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.left, maxLines: 1,),
              ],
            ),
          ),
        ),
        Container(
          height: height*0.125,
          width: width*0.285,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.01),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: themeProvider.isLightTheme()
                ? Border.all(color: const Color(0xFFEDEDED))
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.supervisor_account, size: width*0.1,),
              Text('${userProvider.user!.referrals!.length}', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary), textAlign: TextAlign.left),
              Text( 'Friends', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.left, maxLines: 1,)
            ],
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReferPage()),
            );
          },
          child: Container(
            height: height*0.125,
            width: width*0.285,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.03, vertical: height * 0.01),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              border: themeProvider.isLightTheme()
                  ? Border.all(color: const Color(0xFFEDEDED))
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Icon(LineIcons.userPlus, size: width*0.10, weight: 5, color: Theme.of(context).colorScheme.onSecondaryContainer,),
                Spacer(),
                AutoSizeText('Invite friend', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer), maxLines: 1,)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
