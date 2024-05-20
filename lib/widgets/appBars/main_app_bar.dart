import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:outwork/go_pro_page.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/chat_page.dart';
import 'package:outwork/screens/upgrade_your_plan_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
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
            onTap: () async{
                Offerings? offerings;
                try {
                  offerings = await Purchases.getOfferings();
                } catch (e) {
                  print(e);
                }
                if(offerings != null){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpgradeYourPlanPage(offerings: offerings!,)),
                  );
                }
              // PersistentNavBarNavigator.pushNewScreen(
              //   context,
              //   screen: ChatPage(),
              //   withNavBar: false,
              // );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/jacob.png'),
            ),
          ),
        ),
      ),
      title: Text(
        'Outwork',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: width * 0.04),
          child: InkWell(
              onTap: userProvider.user!.isPremiumUser==false?() async{
                Offerings? offerings;
                try {
                  offerings = await Purchases.getOfferings();
                } catch (e) {
                  print(e);
                }
                if(offerings != null){
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: GoProPage(offerings: offerings,),
                    withNavBar: false,
                  );
                }
              }:null,
              child: Icon(userProvider.user!.isPremiumUser==false?LineIcons.crown:LineIcons.star,
                  color: Theme.of(context).colorScheme.secondary, size: 30)),
        )
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
