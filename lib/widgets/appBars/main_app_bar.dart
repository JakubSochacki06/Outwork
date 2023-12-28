import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: ,
      automaticallyImplyLeading: false,
      // backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
      ],
    );
  }

  @override
  Size get preferredSize =>  new Size.fromHeight(kToolbarHeight);
}
