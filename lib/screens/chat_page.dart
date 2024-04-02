import 'package:flutter/material.dart';
import 'package:outwork/providers/chat_provider.dart';
import 'package:outwork/widgets/chatbot_text_input.dart';
import 'package:outwork/widgets/commonly_used_sentences.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Talk with Jacob Bot',
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
