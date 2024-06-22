import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:outwork/widgets/appBars/settings_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/chat_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Future<bool?> wantToDeleteAccount(BuildContext context) async {
    bool? deleteAccount = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${AppLocalizations.of(context)!.deleteAccount}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          content: Text(AppLocalizations.of(context)!.deleteAccountConfirm,
              style: Theme.of(context).primaryTextTheme.bodySmall),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.no, style: Theme.of(context).textTheme.bodySmall),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.yes,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
          ],
        );
      },
    );
    return deleteAccount;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context);
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: true);

    Future<void> _showLanguageDialog() async{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.chooseLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.english),
                  onTap: () async{
                    await themeProvider.setUserLocale(Locale('en'));
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.polish),
                  onTap: () async {
                    await themeProvider.setUserLocale(Locale('pl'));
                    Navigator.of(context).pop();
                  },
                ),
                // Add more languages here
              ],
            ),
          );
        },
      );
    }
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
            title: Text(AppLocalizations.of(context)!.common),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.language),
                value: Text('${themeProvider.selectedLocale!.languageCode=='en'?AppLocalizations.of(context)!.english:AppLocalizations.of(context)!.polish} (${AppLocalizations.of(context)!.tapToChange})'),
                onPressed: (context) async{
                  await _showLanguageDialog();
                },
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
                title: Text(AppLocalizations.of(context)!.turnOnToughMode),
              ),
              // SettingsTile.switchTile(
              //   onToggle: (value) {},
              //   initialValue: true,
              //   leading: const Icon(Icons.notifications_active),
              //   title: const Text('Enable notifications'),
              // ),
            ],
          ),
          SettingsSection(title: Text(AppLocalizations.of(context)!.account), tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              value: Text(userProvider.user!.email!),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.phone),
              title: Text(AppLocalizations.of(context)!.phone),
              // TODO: ADD PHONE AND VERIFICATION
              // value: Text(userProvider.user!.email!),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logout),
              onPressed: (context) async {
                await Purchases.logOut();
                await FirebaseAuth.instance.signOut();
              },
              // value: Text(userProvider.user!.email!),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.no_accounts),
              title: Text(AppLocalizations.of(context)!.deleteAccount),
              onPressed: (context) async {
                bool? deleteAccount = await wantToDeleteAccount(context);
                if(deleteAccount == true){

                  await Purchases.logOut();
                  await FirebaseAuth.instance.signOut();
                }
              },
              // value: Text(userProvider.user!.email!),
            ),
          ]),
        ],
      ),
    );
  }
}
