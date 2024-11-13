import 'package:flutter/material.dart';

class AIChatWidget extends StatefulWidget {
  const AIChatWidget({super.key});

  @override
  State<AIChatWidget> createState() => _AIChatWidgetState();
}

class Message {
  final String text;
  final bool isUser;

  Message(this.text, this.isUser);
}

class _AIChatWidgetState extends State<AIChatWidget> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Method to add a new message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      setState(() {
        _messages.add(_controller.text);
      });
      _controller.clear();
      _scrollToBottom();

      // Simulate a response with a delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _messages.add("AI Response: $userMessage");
        });
        _scrollToBottom();
      });
    }
  }

  // Automatically scroll to the bottom when a new message is added
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the theme colors
    final primaryColor = Theme.of(context).colorScheme.primary;
    final backgroundColor = Theme.of(context).colorScheme.surface;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final inputBackgroundColor =
        Theme.of(context).colorScheme.surfaceContainerHighest;

    return Scaffold(
      body: Column(
        children: [
          // Scrollable list of chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              },
            ),
          ),
          // Fixed text input field at the bottom
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            color: inputBackgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
