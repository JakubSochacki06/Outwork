import 'package:flutter/material.dart';
import 'package:outwork/providers/chat_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/chatbot_text_input.dart';
import 'package:outwork/widgets/commonly_used_sentences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ChatPage extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    chatProvider.messages.length==0?chatProvider.addAdminSintructions(context, userProvider.user!.toughModeSelected!):null;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.talkWithJacob,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.02, horizontal: width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                controller: _controller,
                reverse: true,
                itemCount: chatProvider.messages.length,
                itemBuilder: (_, int index) => chatProvider.messages[index],
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: height * 0.015,
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.015,
            ),
            Visibility(
              visible: chatProvider.messages.length == 2,
              child: CommonlyUsedSentences(
                scrollController: _controller,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            const ChatbotTextInput()
          ],
        ),
      ),
    );
  }
}
