import 'package:flutter/material.dart';
import 'package:outwork/widgets/chat_message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatProvider with ChangeNotifier {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];
  List<Map<String, String>> _conversationHistory = [];

  List<ChatMessage> get messages => _messages;

  ChatProvider(){
    _handleAdminInstructions();
  }

  void handleSubmitted(String text) {
    _messageController.clear();
    ChatMessage message = ChatMessage(text: text, isUser: true);
    _messages.insert(0, message);
    _conversationHistory.add({'role': 'user', 'content': text});
    notifyListeners(); // Notify listeners to rebuild UI
    callOpenAPI();
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
      _messages.addAll(adminInstructions.map((msg) => ChatMessage(text: msg['content']!, isUser: false)));

    _conversationHistory.addAll(initialUserMessage);
    _conversationHistory.addAll(adminInstructions);
  }

  Future<void> callOpenAPI() async {
      _messages.insert(0, ChatMessage(text: 'typing...', isUser: false));
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      // Example endpoint for text-davinci-003'), // Example endpoint for text-davinci-003'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['token']}',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': _conversationHistory,
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
        _messages.removeAt(0);
        _messages.insert(0, message);
        notifyListeners();
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
    }
  }
}
