import 'package:flutter/material.dart';
import 'package:outwork/providers/navbar_controller_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/profile_page.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      // backgroundColor: Colors.white,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: width * 0.04),
        child: Container(
          width: 58,
          child: GestureDetector(
            onTap: () {
              NavbarControllerProvider navbarControllerProvider = Provider.of<NavbarControllerProvider>(context, listen: false);
              navbarControllerProvider.jumpToTab(3);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(userProvider.user!.photoURL!),
            ),
          ),
        ),
      ),
      actions: [Padding(
        padding: EdgeInsets.only(right: width * 0.04),
        child: IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
      )],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
