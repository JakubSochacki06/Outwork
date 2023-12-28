import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:outwork/screens/planner_page.dart';
import 'package:outwork/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/user_provider.dart';
import 'screens/mental_health_page.dart';
import 'screens/home_page.dart';

class PageNavigator extends StatefulWidget {
  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    PlannerPage(),
    MentalHealthPage(),
    Text('test'),
    // const FridgePage(),
    // FindRecipePage(),
    // const FamilyPage(),
    // const ShoppingListsPage()
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final userProvider =
    Provider.of<UserProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: FutureBuilder(
          future: userProvider.fetchUserData(FirebaseAuth.instance.currentUser!.email!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if(userProvider.user == null){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Loading user', style: kBold22,)
                  ],
                );
              }
              return _widgetOptions.elementAt(_selectedIndex);
            } else {
              return const Center(child: Text('Something went Wrong!'));
            }
          },
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                spreadRadius: 30,
                blurRadius: 50,
                color: Colors.black,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: SafeArea(
              child: GNav(
                // backgroundColor: Colors.purple,
                // rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Theme.of(context).colorScheme.secondary,
                color: Colors.black,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                    textStyle: Theme.of(context).textTheme.displaySmall,
                    // iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    iconColor: Theme.of(context).iconTheme.color,
                  ),
                  GButton(
                    icon: Icons.date_range,
                    text: 'Planner',
                    textStyle: Theme.of(context).textTheme.displaySmall,
                    // iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    iconColor: Theme.of(context).iconTheme.color,
                  ),
                  GButton(
                    icon: Icons.sticky_note_2,
                    text: 'Journal',
                    textStyle: Theme.of(context).textTheme.displaySmall,
                    // iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    iconColor: Theme.of(context).iconTheme.color,
                  ),
                  GButton(
                    icon: Icons.checklist_outlined,
                    text: 'Shopping list',
                    textStyle: Theme.of(context).textTheme.displaySmall,
                    // iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    iconColor: Theme.of(context).iconTheme.color,
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}