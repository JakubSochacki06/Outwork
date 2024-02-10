import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BookTile extends StatelessWidget {
  final String title;
  final String author;
  final int pages;
  final String thumbnailURL;
  BookTile({required this.title, required this.author, required this.pages, required this.thumbnailURL});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height*0.01, horizontal: width*0.05
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Image.network(thumbnailURL, scale: 2,),
          SizedBox(width: width*0.05,),
          Container(
              width:width*0.5,
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Container(child: AutoSizeText(title, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2,)),
                Container(child: AutoSizeText(author, style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer), maxLines: 1,)),
                Container(child: AutoSizeText('$pages pages', style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer), maxLines: 1,)),
              ],
            ),
          ),
          Spacer(),
          IconButton(onPressed: (){}, icon: Icon(Icons.add))
        ],
      ),
    );
  }
}
