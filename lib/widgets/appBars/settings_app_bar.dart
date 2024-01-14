import 'package:flutter/material.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Settings', style: Theme.of(context).textTheme.bodyLarge),
      centerTitle: true,
      leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.navigate_before)),
    );
  }

  @override
  Size get preferredSize =>  new Size.fromHeight(kToolbarHeight);
}