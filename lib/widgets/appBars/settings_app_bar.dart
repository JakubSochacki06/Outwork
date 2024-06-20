import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      title: Text(AppLocalizations.of(context)!.settings, style: Theme.of(context).textTheme.bodyLarge),
      centerTitle: true,
      leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.navigate_before)),
    );
  }

  @override
  Size get preferredSize =>  const Size.fromHeight(kToolbarHeight);
}