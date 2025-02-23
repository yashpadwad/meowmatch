import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with a Match")),
      body: Column(
        children: [
          Expanded(child: ListView(children: [Text("Start chatting! 🐱💕")])),
          TextField(decoration: InputDecoration(hintText: "Type a message...")),
        ],
      ),
    );
  }
}
