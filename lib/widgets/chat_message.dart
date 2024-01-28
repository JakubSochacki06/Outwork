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
      child: Row(
        children: <Widget>[
          isUser
              ? Container(
            width: width * 0.12,
            child: CircleAvatar(
                backgroundImage:
                NetworkImage(userProvider.user!.photoURL!)),
          )
              : Container(
            width: width * 0.12,
            child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/jacob.png')),
          ),
          SizedBox(width: width*0.03,),
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
                    style: Theme.of(context).textTheme.labelLarge,
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