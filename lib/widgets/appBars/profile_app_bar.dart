import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('My profile', style: Theme.of(context).textTheme.bodyLarge),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: (){
            Navigator.pushNamed(context, '/settings');
          },
          icon: Icon(Icons.settings),
        ),
      ]
    );
  }

  @override
  Size get preferredSize =>  new Size.fromHeight(kToolbarHeight);
}