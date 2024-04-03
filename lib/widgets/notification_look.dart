import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NotificationLook extends StatelessWidget {
  final String title;
  final String text;

  NotificationLook({required this.title, required this.text});

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
            child: const FittedBox(
              fit: BoxFit.contain,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/logo.png'),
              ),
            ),
          ),
          SizedBox(width: width*0.02,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[AutoSizeText(title,
                    style: Theme.of(context).textTheme.bodyMedium, maxLines:1),
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