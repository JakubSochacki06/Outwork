import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageName;
  final bool isSelected;
  CarouselItem({required this.title, required this.description, required this.imageName, required this.isSelected});

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
        border: Border.all(width: 2, color: isSelected?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(title, style: Theme.of(context).textTheme.displaySmall, maxLines: 1,),
          Image.asset('assets/images/$imageName.png', height: height*0.1,),
          Text(description, style: Theme.of(context).primaryTextTheme.bodyMedium, textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
