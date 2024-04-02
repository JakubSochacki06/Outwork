import 'package:flutter/material.dart';

class ReferAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReferAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      title: Text('Refer & Earn', style: Theme.of(context).textTheme.bodyLarge),
      centerTitle: true,
      leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.navigate_before)),
    );
  }

  @override
  Size get preferredSize =>  new Size.fromHeight(kToolbarHeight);
}