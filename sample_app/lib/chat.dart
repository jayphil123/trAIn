import 'package:flutter/material.dart';
import 'components/chat_widget.dart';

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
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Chat with trAIn',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            elevation: 2,
          ),
        ),
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
