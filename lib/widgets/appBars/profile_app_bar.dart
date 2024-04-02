import 'package:flutter/material.dart';
import 'package:outwork/screens/chat_page.dart';
import 'package:outwork/screens/profile_page/settings_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      title: Text('My profile', style: Theme.of(context).textTheme.bodyLarge),
      centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: width * 0.04),
          child: Container(
            width: 58,
            child: GestureDetector(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: ChatPage(),
                  withNavBar: false,
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/jacob.png'),
              ),
            ),
          ),
        ),
      actions: [
        IconButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ]
    );
  }

  @override
  Size get preferredSize =>  const Size.fromHeight(kToolbarHeight);
}