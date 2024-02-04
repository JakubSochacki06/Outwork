import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/screens/profile_page/settings_page.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      title: Text('My profile', style: Theme.of(context).textTheme.bodyLarge),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          icon: Icon(Icons.settings),
        ),
      ]
    );
  }

  @override
  Size get preferredSize =>  new Size.fromHeight(kToolbarHeight);
}