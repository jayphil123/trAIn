import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme.dart';
import '../user_data/talk.dart';

bool changeSplit = false;
Map<String, dynamic> mostRecentMessage = {};

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
  bool _isScrolledToBottom = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Wait for the ListView to finish rendering
      _scrollToBottom();
    });

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    // _clearChatHistory();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      setState(() {
        _isScrolledToBottom = currentScroll >= (maxScroll - 20);
      });
    }
  }

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

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String messagesJson =
    jsonEncode(_messages.map((msg) => msg.toJson()).toList());
    await prefs.setString('messages', messagesJson);
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;

      setState(() {
        _messages.add(Message(userMessage, true));
        _messages.add(Message("loading", false));
      });
      _controller.clear();
      _scrollToBottom();
      _saveMessages();

      Map<String, dynamic> response = await chatMessage(context, userMessage);

      String aiMessage = handleAiMessage(response, context);

      setState(() {
        _messages.removeLast();
        _messages.add(Message(aiMessage, false));
      });
      _scrollToBottom();
      _saveMessages();
    }
  }

  Future<void> _clearChatHistory() async {
    setState(() {
      _messages.clear();
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('messages');
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
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
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.secondaryBackground,
        elevation: 0,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/train-white-logo.png',
              width: 110,
              height: 110,
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            color: AppTheme.primaryBackground,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'clear') {
                _clearChatHistory();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: const Text(
                  'Clear Chat History',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                        child: Text(
                          "What can I help you with?",
                          style: AppTheme.subTitleTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Padding(
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
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  child: isLoading
                                      ? Container(
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: AppTheme.secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Thinking...",
                                                style: TextStyle(
                                                    color: AppTheme
                                                        .bodyTextStyle.color),
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
                                              topLeft:
                                                  const Radius.circular(12),
                                              topRight:
                                                  const Radius.circular(12),
                                              bottomLeft: isUserMessage
                                                  ? const Radius.circular(12)
                                                  : const Radius.circular(0),
                                              bottomRight: isUserMessage
                                                  ? const Radius.circular(0)
                                                  : const Radius.circular(12),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                message.text,
                                                style: TextStyle(
                                                    color: AppTheme
                                                        .bodyTextStyle.color),
                                              ),
                                              if (!isUserMessage && changeSplit)
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppTheme.primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        updateWorkouts(mostRecentMessage, context);
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "CONFIRM WORKOUT",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
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
                        onSubmitted: (value) async {
                          await _sendMessage();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        await _sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!_isScrolledToBottom)
            Positioned(
              bottom: 60,
              left: MediaQuery.of(context).size.width / 2 - 25,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppTheme.primaryColor,
                onPressed: _scrollToBottom,
                child: const Icon(Icons.arrow_downward),
              ),
            ),
        ],
      ),
    );
  }
}

String handleAiMessage(Map<String, dynamic> response, context) {
  print(response);
  if (response["status"] == 2 || response["status"] == 1) {
    changeSplit = true;
    mostRecentMessage = response;
    String thing = formatWorkoutSplit(response);

    return thing;
  } else if (response["status"] == 3) {
    changeSplit = false;
    return response["content"];
  } else {
    changeSplit = false;
    return "Error generating message.";
  }
}

String formatWorkoutSplit(Map<String, dynamic> workoutSplit) {
  String formattedSplit = "";

  List<String> days = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  // Capitalize the first letter of the day
  String capitalize(String input) => input[0].toUpperCase() + input.substring(1);

  // Check if 'content' is a Map<String, dynamic>
  if (workoutSplit["content"] is Map<String, dynamic>) {
    Map<String, dynamic> workouts = workoutSplit["content"];

    for (String day in days) {
      if (workouts[day] is List) {
        // Cast to List<Map<String, dynamic>> after verifying it's a List
        List<Map<String, dynamic>> newDay =
            List<Map<String, dynamic>>.from(workouts[day]);

        formattedSplit += "${capitalize(day)}:\n";
        for (Map<String, dynamic> workout in newDay) {
          formattedSplit += "\t- ${workout["workout"]}\n";
        }
      }
    }
  } else {
    print("Error: 'content' is not a Map.");
  }

  return formattedSplit;
}
