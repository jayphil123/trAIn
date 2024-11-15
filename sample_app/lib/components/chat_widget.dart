import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['text'],
      json['isUser'],
    );
  }
}

class _AIChatWidgetState extends State<AIChatWidget> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Wait for the ListView to finish rendering
      _scrollToBottom();
    });
    // _clearChatHistory();
  }

  // Method to load messages from local storage
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesJson = prefs.getString('messages');
    if (messagesJson != null) {
      final List<dynamic> decodedMessages = jsonDecode(messagesJson);
      setState(() {
        _messages.clear();
        _messages.addAll(decodedMessages.map((msg) => Message.fromJson(msg)));
      });
    }
  }

  // Method to save messages to local storage
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String messagesJson =
        jsonEncode(_messages.map((msg) => msg.toJson()).toList());
    // print(messagesJson);
    await prefs.setString('messages', messagesJson);
  }

  // Method to add a new message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      setState(() {
        _messages.add(Message(userMessage, true));
        _messages.add(Message("loading", false));
      });
      _controller.clear();
      _scrollToBottom();
      _saveMessages();

      // Simulate a response with a delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _messages.removeLast();
          _messages.add(Message("AI: $userMessage", false));
        });
        _scrollToBottom();
        _saveMessages();
      });
    }
  }

  Future<void> _clearChatHistory() async {
    setState(() {
      _messages.clear(); // Clear the in-memory list
    });

    // Clear the persisted messages from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('messages'); // Remove the 'messages' key
  }

  // Automatically scroll to the bottom when a new message is added
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Use a Future and addPostFrameCallback to ensure the UI is fully built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back button
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/train-white-logo.png', // Path to your logo image
              width: 110,
              height: 110,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Scrollable list of chat messages
          Expanded(
              child: Container(
                  // color: Colors.white,
                  child: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.isUser;
                final isLoading = message.text == "loading";

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
                        child: isLoading
                            ? Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Thinking...",
                                      style: TextStyle(
                                          color: AppTheme.bodyTextStyle.color),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
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
                                  style: TextStyle(
                                      color: AppTheme.bodyTextStyle.color),
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ))),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
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
