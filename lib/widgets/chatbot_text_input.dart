import 'package:flutter/material.dart';
import 'package:outwork/providers/chat_provider.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ChatbotTextInput extends StatefulWidget {
  const ChatbotTextInput({super.key});

  @override
  State<ChatbotTextInput> createState() => _ChatbotTextInputState();
}

class _ChatbotTextInputState extends State<ChatbotTextInput> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .primary,
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
                  hintStyle: Theme
                      .of(context)
                      .primaryTextTheme
                      .labelLarge),
            ),
          ),
          Text('${chatProvider.freeMessages}/10', style: Theme.of(context).textTheme.bodySmall,),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async{
              await chatProvider.handleSubmitted(_messageController.text, userProvider.user!.email!, context);
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
