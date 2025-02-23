import 'package:flutter/material.dart';
import '../widgets/gradient_wrapper.dart';

class MessagePage extends StatefulWidget {
  final String catName;
  const MessagePage({super.key, required this.catName});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> messages = [];
  bool _isSendButtonPressed = false;

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add(_messageController.text);
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Chat with ${widget.catName} 🐱", style: TextStyle(fontFamily: "Poppins", color: Colors.white)),
          backgroundColor: Colors.pink,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.pink[100] : Colors.blue[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(messages[index], style: TextStyle(fontSize: 16, fontFamily: "Montserrat", color: Colors.black87)),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(fontFamily: "Montserrat", color: Colors.white70),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTapDown: (_) => setState(() => _isSendButtonPressed = true),
                    onTapUp: (_) {
                      setState(() => _isSendButtonPressed = false);
                      sendMessage();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      transform: _isSendButtonPressed 
                          ? (Matrix4.identity()..scale(1.1)) 
                          : Matrix4.identity(),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.circle,
                        boxShadow: _isSendButtonPressed
                            ? [BoxShadow(color: Colors.pink.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)]
                            : [],
                      ),
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.send, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
