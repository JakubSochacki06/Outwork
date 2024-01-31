import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:outwork/providers/navbar_controller_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/chat_page.dart';
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
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: width * 0.04),
        child: Container(
          width: 58,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/jacob.png'),
            ),
          ),
        ),
      ),
      title: Text('Outwork', style: Theme.of(context).textTheme.bodyLarge,),
      actions: [Padding(
        padding: EdgeInsets.only(right: width * 0.04),
        child: InkWell(onTap: () {}, child: Icon(LineIcons.crown, color: Theme.of(context).colorScheme.secondary, size: 30)),
      )],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
