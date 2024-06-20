import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              '${AppLocalizations.of(context)!.youJustEarned} $amount XP!',
              style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            const Spacer(),
            Icon(
              Icons.show_chart,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
