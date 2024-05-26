import 'package:flutter/material.dart';
import 'package:outwork/providers/chat_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
          'Commonly used',
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
                    chatProvider.handleSubmitted('I\'m not feeling alright', userProvider.user!.email!, userProvider.user!.isPremiumUser!,context);
                  },
                  child: Text('I\'m not feeling alright', style: Theme.of(context).textTheme.labelSmall,),
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
                    chatProvider.handleSubmitted('I don\'t have motivation', userProvider.user!.email!, userProvider.user!.isPremiumUser!, context);
                    // _scrollDown();
                  },
                  child: Text('I don\'t have motivation', style: Theme.of(context).textTheme.labelSmall,),
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
                    chatProvider.handleSubmitted('I\'m tired', userProvider.user!.email!, userProvider.user!.isPremiumUser!, context);
                    // _scrollDown();
                  },
                  child: Text('I\'m tired', style: Theme.of(context).textTheme.labelSmall,),
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
                    chatProvider.handleSubmitted('I might give up soon', userProvider.user!.email!, userProvider.user!.isPremiumUser!, context);
                    // _scrollDown();
                  },
                  child: Text('I might give up soon', style: Theme.of(context).textTheme.labelSmall,),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
