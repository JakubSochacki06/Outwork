import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavbarControllerProvider extends ChangeNotifier {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  PersistentTabController get controller => _controller;

  void jumpToTab(int index){
    _controller.jumpToTab(index);
    notifyListeners();
  }
}