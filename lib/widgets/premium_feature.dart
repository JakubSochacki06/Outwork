import 'package:flutter/material.dart';

class PremiumFeature extends StatelessWidget {
  final IconData leftIcon;
  final String title;
  final String description;
  const PremiumFeature({required this.leftIcon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            leftIcon,
            color: Theme.of(context).colorScheme.secondary,
            size: 60,
          ),
          SizedBox(width: width*0.03,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium,),
                Text(description, style: Theme.of(context).primaryTextTheme.bodySmall, maxLines: 2,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
