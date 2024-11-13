import 'package:flutter/material.dart';
import '../theme.dart';

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
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Method to add a new message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      setState(() {
        _messages.add(Message(userMessage, true));
      });
      _controller.clear();
      _scrollToBottom();

      // Simulate a response with a delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _messages.add(Message("Ai: $userMessage", false));
        });
      });
      _scrollToBottom();
    }
  }

  // Automatically scroll to the bottom when a new message is added
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Scrollable list of chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.isUser;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Align(
                    alignment: isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Align(
                      alignment: isUserMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? AppTheme.primaryColor
                                : AppTheme.secondaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: isUserMessage
                                  ? const Radius.circular(12)
                                  : const Radius.circular(0),
                              bottomRight: isUserMessage
                                  ? const Radius.circular(0)
                                  : const Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            message.text,
                            style:
                                TextStyle(color: AppTheme.bodyTextStyle.color),
                          ),
                        ),
                      ),
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
            color: AppTheme.secondaryBackground,
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
