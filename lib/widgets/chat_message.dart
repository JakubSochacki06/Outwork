import 'package:flutter/material.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width*0.01, vertical: height*0.01),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: width * 0.12,
            child: CircleAvatar(
              backgroundImage: isUser
                  ? NetworkImage(userProvider.user!.photoURL!)
                  : Image.asset('assets/images/jacob.png').image,
            ),
          ),
          SizedBox(width: width*0.02,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isUser
                    ? Text(userProvider.user!.displayName!,
                    style: Theme.of(context).textTheme.bodyMedium)
                    : Text('Jacob Bot',
                    style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(
                  height: height * 0.001,
                ),
                Container(
                  child: Text(
                    text,
                    style: Theme.of(context).primaryTextTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}