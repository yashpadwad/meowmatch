import 'package:flutter/material.dart';
import '../widgets/gradient_wrapper.dart';

class MessagePage extends StatefulWidget {
  final String catName; // ✅ Ensure catName is required
  const MessagePage({super.key, required this.catName});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isSendButtonPressed = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage() {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(text);
        _messageController.clear();
      });

      // ✅ Scroll to the bottom after sending a message
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Chat with ${widget.catName} 🐱",
            style: const TextStyle(fontFamily: "Poppins", color: Colors.white),
          ),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Column(
          children: [
            // ✅ Chat Messages Section
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isUserMessage = index % 2 != 0; // Alternate messages

                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.blue[200] : Colors.pink[200],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomLeft: isUserMessage ? const Radius.circular(15) : Radius.zero,
                          bottomRight: isUserMessage ? Radius.zero : const Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        messages[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ✅ Message Input Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // ✅ Text Input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        hintText: "Type a message...",
                        hintStyle: const TextStyle(fontFamily: "Montserrat", color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ✅ Send Button with Ripple Effect
                  GestureDetector(
                    onTapDown: (_) => setState(() => _isSendButtonPressed = true),
                    onTapUp: (_) {
                      setState(() => _isSendButtonPressed = false);
                      sendMessage();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      transform: _isSendButtonPressed
                          ? (Matrix4.identity()..scale(1.1))
                          : Matrix4.identity(),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.circle,
                        boxShadow: _isSendButtonPressed
                            ? [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : [],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.send, color: Colors.white, size: 24),
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

