import 'package:flutter/material.dart';
import 'package:outwork/providers/chat_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../providers/user_provider.dart';
import '../screens/upgrade_your_plan_page.dart';

class ChatbotTextInput extends StatefulWidget {
  const ChatbotTextInput({super.key});

  @override
  State<ChatbotTextInput> createState() => _ChatbotTextInputState();
}

class _ChatbotTextInputState extends State<ChatbotTextInput> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration.collapsed(
                  hintText: 'Write Question',
                  // hintTextDirection: TextDirection.rtl,
                  hintStyle: Theme.of(context).primaryTextTheme.labelLarge),
            ),
          ),
          Visibility(
            visible: !userProvider.user!.isPremiumUser!,
              child: Text(
            '${chatProvider.freeMessages}/5',
            style: Theme.of(context).textTheme.bodySmall,
          ),),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if(_messageController.text.length > 0){
                await chatProvider.handleSubmitted(_messageController.text, userProvider.user!.email!, userProvider.user!.isPremiumUser!, context);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
