import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:outwork/providers/navbar_controller_provider.dart';
import 'package:outwork/screens/profile_page/profile_page.dart';
import 'package:outwork/screens/progress_page/progress_page.dart';
import 'package:outwork/screens/projects_page/projects_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/user_provider.dart';
import 'screens/home_page/home_page.dart';

class PageNavigator extends StatefulWidget {
  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  List<Widget> _buildScreens() {
    return [
      HomePage(),
      ProjectsPage(),
      ProgressPage(),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          icon: Icon(LineIcons.home),
          inactiveColorPrimary: Theme.of(context).iconTheme.color,
          title: ('Home'),
          textStyle: Theme.of(context).textTheme.labelMedium
          // activeColorPrimary: CupertinoColors.activeBlue,
          // inactiveColorPrimary: CupertinoColors.systemGrey,
          ),
      PersistentBottomNavBarItem(
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          icon: Icon(LineIcons.calendarCheck),
          inactiveColorPrimary: Theme.of(context).iconTheme.color,
          title: ('Projects'),
          textStyle: Theme.of(context).textTheme.labelMedium),
      PersistentBottomNavBarItem(
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          icon: Icon(Icons.show_chart),
          inactiveColorPrimary: Theme.of(context).iconTheme.color,
          title: ('Progress'),
          textStyle: Theme.of(context).textTheme.labelMedium),
      PersistentBottomNavBarItem(
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          icon: Icon(Icons.person_outline),
          inactiveColorPrimary: Theme.of(context).iconTheme.color,
          title: ("Profile"),
          textStyle: Theme.of(context).textTheme.labelMedium),
    ];
  }

  @override
  Widget build(BuildContext context) {
    NavbarControllerProvider navbarControllerProvider =
        Provider.of<NavbarControllerProvider>(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // final userProvider =
    // Provider.of<UserProvider>(context, listen: true);
    return PersistentTabView(
      resizeToAvoidBottomInset: false,
      context,
      controller: navbarControllerProvider.controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      decoration: NavBarDecoration(boxShadow: [
        BoxShadow(
          spreadRadius: 15,
          blurRadius: 25,
          color: Colors.black,
        )
      ]),
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
