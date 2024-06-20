import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorLoginSnackBar {

  const ErrorLoginSnackBar();

  static show(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.thisUserDoesntExist,
              style: Theme.of(context).primaryTextTheme.bodySmall,
            ),
            const Spacer(),
            Icon(
              Icons.close,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
