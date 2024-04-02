import 'package:flutter/material.dart';

class ReferTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  const ReferTile({required this.imagePath, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Image.asset('assets/images/$imagePath.png', scale: 1.2,),
        SizedBox(width: width*0.03,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$title', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondary),),
              Text('$description', style: Theme.of(context).primaryTextTheme.bodySmall,)
            ],
          ),
        ),
      ],
    );
  }
}
