import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:outwork/widgets/appBars/settings_app_bar.dart';

import '../../providers/chat_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context);
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: true);
    print(userProvider.user!.toughModeSelected);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SettingsAppBar(),
      body: SettingsList(
        // TODO: CHECK IF THIS IS ANDROID OR IOS AND CUSTOMIZE IT
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).colorScheme.background,
          settingsSectionBackground: Theme.of(context).colorScheme.background,
        ),
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
              ),
              // SettingsTile.switchTile(
              //   onToggle: (value) {
              //     setState(() {
              //       themeProvider.enableLightTheme(value);
              //     });
              //   },
              //   initialValue: themeProvider.isLightTheme(),
              //   leading: Icon(Icons.format_paint),
              //   title: Text('Enable light theme'),
              // ),
              SettingsTile.switchTile(
                onToggle: (value) async{
                  await userProvider.updateMode(value);
                  ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);
                  chatProvider.resetConversation(context);
                },
                initialValue: userProvider.user!.toughModeSelected,
                leading: const Icon(Icons.local_fire_department),
                title: const Text('Turn on tough mode'),
              ),
              // SettingsTile.switchTile(
              //   onToggle: (value) {},
              //   initialValue: true,
              //   leading: const Icon(Icons.notifications_active),
              //   title: const Text('Enable notifications'),
              // ),
            ],
          ),
          SettingsSection(title: const Text('Account'), tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              value: Text(userProvider.user!.email!),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              // TODO: ADD PHONE AND VERIFICATION
              // value: Text(userProvider.user!.email!),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onPressed: (context) async {
                await Purchases.logOut();
                await FirebaseAuth.instance.signOut();
              },
              // value: Text(userProvider.user!.email!),
            ),
          ]),
        ],
      ),
    );
  }
}
