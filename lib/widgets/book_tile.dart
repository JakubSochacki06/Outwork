import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/book.dart';

class BookTile extends StatelessWidget {
  final void Function() onAddClicked;
  final Book book;
  BookTile({required this.book, required this.onAddClicked});

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
          Image.network(book.thumbnailURL!, scale: 2,),
          SizedBox(width: width*0.05,),
          Expanded(
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Container(child: AutoSizeText(book.title!, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2,)),
                Container(child: AutoSizeText(book.author!, style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer), maxLines: 1,)),
                Container(child: AutoSizeText('${book.totalPages} ${AppLocalizations.of(context)!.pages}', style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer), maxLines: 1,)),
              ],
            ),
          ),
          IconButton(onPressed: onAddClicked, icon: Icon(Icons.add))
        ],
      ),
    );
  }
}
