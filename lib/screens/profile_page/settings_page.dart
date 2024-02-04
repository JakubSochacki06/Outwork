import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:outwork/widgets/appBars/settings_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SettingsAppBar(),
      body: SettingsList(
        // TODO: CHECK IF THIS IS ANDROID OR IOS AND CUSTOMIZE IT
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).colorScheme.background,
          settingsSectionBackground: Theme.of(context).colorScheme.background,
        ),
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  print(value);
                  setState(() {
                    themeProvider.enableLightTheme(value);
                  });
                },
                initialValue: themeProvider.isLightTheme(),
                leading: Icon(Icons.format_paint),
                title: Text('Enable light theme'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.notifications_active),
                title: Text('Enable notifications'),
              ),
            ],
          ),
          SettingsSection(title: Text('Account'), tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.email),
              title: Text('Email'),
              value: Text(userProvider.user!.email!),
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
              // TODO: ADD PHONE AND VERIFICATION
              // value: Text(userProvider.user!.email!),
            ),
          ]),
        ],
      ),
    );
  }
}
