import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const BasicAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      centerTitle: true,
      leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.navigate_before)),
    );
  }

  @override
  Size get preferredSize =>  const Size.fromHeight(kToolbarHeight);
}