import 'package:flutter/material.dart';

class EarnedXPSnackbar {

  const EarnedXPSnackbar();

  static show(BuildContext context, int amount) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Text(
              'You just earned $amount XP!',
              style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            Spacer(),
            Icon(
              Icons.show_chart,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ],
        ),
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
