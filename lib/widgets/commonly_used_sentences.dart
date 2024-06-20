import 'package:flutter/material.dart';
import 'package:outwork/providers/chat_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonlyUsedSentences extends StatelessWidget {
  final ScrollController scrollController;
  const CommonlyUsedSentences({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // void _scrollDown() {
    //   scrollController.animateTo(
    //     scrollController.position.maxScrollExtent,
    //     duration: Duration(seconds: 5),
    //     curve: Curves.fastOutSlowIn,
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.commonlyUsed,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: height * 0.005,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: (){
                    chatProvider.handleSubmitted(AppLocalizations.of(context)!.imNotFeelingAlright, userProvider.user!.email!, userProvider.user!.isPremiumUser!,context);
                  },
                  child: Text(AppLocalizations.of(context)!.imNotFeelingAlright, style: Theme.of(context).textTheme.labelSmall,),
                ),
              ),
              SizedBox(width: width*0.01,),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: (){
                    chatProvider.handleSubmitted(AppLocalizations.of(context)!.iDontHaveMotivation, userProvider.user!.email!, userProvider.user!.isPremiumUser!, context);
                    // _scrollDown();
                  },
                  child: Text(AppLocalizations.of(context)!.iDontHaveMotivation, style: Theme.of(context).textTheme.labelSmall,),
                ),
              ),
              SizedBox(width: width*0.01,),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: (){
                    chatProvider.handleSubmitted(AppLocalizations.of(context)!.imTired, userProvider.user!.email!, userProvider.user!.isPremiumUser!, context);
                    // _scrollDown();
                  },
                  child: Text(AppLocalizations.of(context)!.imTired, style: Theme.of(context).textTheme.labelSmall,),
                ),
              ),
              SizedBox(width: width*0.01,),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: (){
                    chatProvider.handleSubmitted(AppLocalizations.of(context)!.iMightGiveUp, userProvider.user!.email!, userProvider.user!.isPremiumUser!, context);
                    // _scrollDown();
                  },
                  child: Text(AppLocalizations.of(context)!.iMightGiveUp, style: Theme.of(context).textTheme.labelSmall,),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
