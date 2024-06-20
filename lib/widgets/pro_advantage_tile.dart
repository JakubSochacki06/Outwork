import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProAdvantageTile extends StatelessWidget {
  final String text;
  const ProAdvantageTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return               Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.check,
          color: Theme.of(context).colorScheme.secondary,
          size: 35,
        ),
        Flexible(
          child: AutoSizeText(text,
            style: Theme.of(context).primaryTextTheme.bodySmall, maxLines: 1,),
        )
      ],
    );
  }
}
