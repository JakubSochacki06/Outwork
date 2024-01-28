import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/chat_page.dart';
import 'package:outwork/widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];
  List<Map<String, String>> _conversationHistory = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Talk with Jacob Bot'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 0.02, left: width * 0.04, right: width * 0.04),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, int index) => _messages[index],
                separatorBuilder: (context, index){
                  return SizedBox(height: height*0.03,);
                },
              ),
            ),
            SizedBox(height: height*0.03,),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).iconTheme.color),
      child: Container(
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _messageController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_messageController.text),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    ChatMessage message = ChatMessage(text: text, isUser: true);
    setState(() {
      _messages.insert(0, message);
      _conversationHistory.add({'role': 'user', 'content': text});
    });
    // Call OpenAI API to get a response
    callOpenAPI(_conversationHistory);
  }

  void _handleAdminInstructions() {
    // Admin provides initial instructions for a friendly conversation with "Jacob Bot"
    List<Map<String, String>> adminInstructions = [
      {
        'role': 'assistant',
        'content':
            'I\'m here to chat with you about anything and provide a listening ear. Feel free to share your thoughts, ask questions, or just chat away!'
      },
      {
        'role': 'assistant',
        'content': 'Hey there! I\'m Jacob Bot, your friendly chat companion.'
      },
    ];

    List<Map<String, String>> initialUserMessage = [
      {
        'role': 'user',
        'content':
            'Act as a friendly bot named Jacob Bot. Treat me like a best friend so I can trust you. If a situation doesn\'t need it answer as short as possible, but it still should be meaningful. You can use emojis, because it creates positive vibe, but dont overuse it! Be the one who stretches out hand first, for example instead of asking me what I would like to talk about, just ask.'
      },
    ];

    // Display introduction messages
    setState(() {
      _messages.addAll(adminInstructions
          .map((msg) => ChatMessage(text: msg['content']!, isUser: false)));
    });

    _conversationHistory.addAll(initialUserMessage);
    _conversationHistory.addAll(adminInstructions);
  }

  @override
  void initState() {
    super.initState();
    // Call admin instructions when the screen initializes
    _handleAdminInstructions();
  }

  Future<void> callOpenAPI(
      List<Map<String, String>> conversationHistory) async {
    setState(() {
      _messages.insert(0,ChatMessage(text: 'typing...', isUser: false));
    });
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      // Example endpoint for text-davinci-003'), // Example endpoint for text-davinci-003'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${dotenv.env['token']}',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': conversationHistory,
        'max_tokens': 250
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String assistantReply =
          utf8.decode(data['choices'][0]['message']['content'].runes.toList());
      _conversationHistory
          .add({'role': 'assistant', 'content': assistantReply});
      ChatMessage message = ChatMessage(text: assistantReply, isUser: false);
      setState(() {
        _messages.removeAt(0);
        _messages.insert(0, message);
      });
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
    }
  }
}
