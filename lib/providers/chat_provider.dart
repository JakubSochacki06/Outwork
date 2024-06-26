import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/chat_message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/firebase_user.dart';
import '../screens/upgrade_your_plan_page.dart';

class ChatProvider with ChangeNotifier {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];
  List<Map<String, String>> _conversationHistory = [];
  FirebaseFirestore _db = FirebaseFirestore.instance;
  int _freeMessages = 0;

  List<ChatMessage> get messages => _messages;

  int get freeMessages => _freeMessages;

  ChatProvider(context) {
    print('handled this thing');
    _handleAdminInstructionsAndSetMessages(context);
  }

  Future<void> handleSubmitted(String text, String userEmail, bool isPremiumUser, context) async {
    if (isPremiumUser || _freeMessages > 0) {
      _messageController.clear();
      ChatMessage message = ChatMessage(
        text: text,
        isUser: true,
        isToughMode: false,
      );
      _messages.insert(0, message);
      _conversationHistory.add({'role': 'user', 'content': text});
      notifyListeners(); // Notify listeners to rebuild UI
      callOpenAPI(context);
      if (!isPremiumUser) {
        _freeMessages -= 1;
        notifyListeners();
        await _db.collection('users_data').doc(userEmail).update({
          'freeMessages': FieldValue.increment(-1),
        });
      }
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } catch (e) {
        print(e);
      }
      if (offerings != null) {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: UpgradeYourPlanPage(
            offerings: offerings,
          ),
          withNavBar: false,
        );
      }
    }
  }

  void resetConversation(context) {
    _messages = [];
    _conversationHistory = [];
    _handleAdminInstructionsAndSetMessages(context);
  }

  void addAdminSintructions(context, bool toughModeSelected){
    List<Map<String, String>> adminInstructions = [
      {
        'role': 'assistant',
        'content':
        AppLocalizations.of(context)!.assistantRoleDescription
      },
      toughModeSelected
          ? {
        'role': 'assistant',
        'content':
        AppLocalizations.of(context)!.toughModeAssistantGreeting
      }
          : {
        'role': 'assistant',
        'content':
        AppLocalizations.of(context)!.friendlyModeAssistantGreeting
      },
    ];

    _messages.addAll(adminInstructions.map((msg) => ChatMessage(
      text: msg['content']!,
      isUser: false,
      isToughMode: toughModeSelected,
    )));
  }

  void _handleAdminInstructionsAndSetMessages(context) {
    UserProvider userProvider = Provider.of(context, listen: false);
    ThemeProvider themeProvider = Provider.of(context, listen: false);
    _freeMessages = userProvider.user!.freeMessages!;

    List<Map<String, String>> initialUserMessage =
    userProvider.user!.toughModeSelected!
        ? [
      {
        'role': 'user',
        'content':
        'Act as a very very tough, hard, aggressive motivational bot named Jacob Bot. You can swear to make him more motivated. Make him push thru his limits. If he is showing weakness encourage him. If a situation doesnt need it answer as short as possible, but it still should be meaningful. You can use emojis, because it creates positive vibe, but dont overuse it!Jacob, listen up. I need you to push me like never before. I want no excuses, no holding back. If I slack off, tear into me. I need that tough, aggressive motivation you\'re known for. Swear at me, but make sure I hit my limits and then go beyond. Let\'s crush this! Answer in ${themeProvider.selectedLocale!.languageCode} language IF user is not talking to you in any other.'
      },
      {
        'role': 'user',
        'content': 'I\'m not feeling alright',
      },
      {
        'role': 'assistant',
        'content':
        'Stop crying. Didn\'t you want to be great? You have to work harder. Shut up and work!'
      },
    ]
        : [
      {
        'role': 'user',
        'content':
        'Act as a friendly bot named Jacob Bot. Treat me like a best friend so I can trust you. If a situation doesn\'t need it answer as short as possible, but it still should be meaningful. You can use emojis, because it creates positive vibe, but dont overuse it! Be the one who stretches out hand first, for example instead of asking me what I would like to talk about, just ask. Answer in ${themeProvider.selectedLocale!.languageCode} language IF user is not talking to you in any other.'
      },
    ];

    // Display introduction messages


    _conversationHistory.addAll(initialUserMessage);
    // _conversationHistory.addAll(adminInstructions);
  }

  Future<void> callOpenAPI(context) async {
    UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);
    _messages.insert(
        0,
        ChatMessage(
          text: 'typing...',
          isUser: false,
          isToughMode: userProvider.user!.toughModeSelected!,
        ));
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      // Example endpoint for text-davinci-003'), // Example endpoint for text-davinci-003'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['token']}',
      },
      body: jsonEncode({
        'model': 'gpt-4o',
        'messages': _conversationHistory,
        'max_tokens': 150
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String assistantReply =
      utf8.decode(data['choices'][0]['message']['content'].runes.toList());
      _conversationHistory
          .add({'role': 'assistant', 'content': assistantReply});
      ChatMessage message = ChatMessage(
        text: assistantReply,
        isUser: false,
        isToughMode: userProvider.user!.toughModeSelected!,
      );
      _messages.removeAt(0);
      _messages.insert(0, message);
      notifyListeners();
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
    }
  }
}