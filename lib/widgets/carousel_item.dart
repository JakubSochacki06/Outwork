import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageName;
  ProgressCard({required this.title, required this.description, required this.imageName});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width*0.6,
      padding: EdgeInsets.symmetric(vertical: height*0.01, horizontal: width*0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(title, style: Theme.of(context).textTheme.bodyLarge, maxLines: 1,),
          SizedBox(height: height*0.01,),
          Expanded(child: Image.asset('assets/images/$imageName.png',)),
          SizedBox(height: height*0.01,),
          AutoSizeText(description, style: Theme.of(context).primaryTextTheme.bodyMedium, textAlign: TextAlign.center, maxLines: 2,)
        ],
      ),
    );
  }
}
