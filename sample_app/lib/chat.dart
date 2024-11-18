import 'package:flutter/material.dart';
import 'components/chat_widget.dart';
import 'theme.dart';

class TrAInChatWidget extends StatefulWidget {
  const TrAInChatWidget({super.key});

  @override
  State<TrAInChatWidget> createState() => _TrAInChatWidgetState();
}

class _TrAInChatWidgetState extends State<TrAInChatWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Column(
            children: const [
              Expanded(child: AIChatWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
