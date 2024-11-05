import '/components/workout_schedule.dart';
import 'package:flutter/material.dart';

class HomepageWidget extends StatefulWidget {
  /// Original homepage for trAin.
  const HomepageWidget({super.key});

  @override
  State<HomepageWidget> createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Row(
            children: [
              const Text("Welcome, [USER]"),
              const SizedBox(width: 40), // Space between logo and text
              Image.asset(
                'assets/images/train-white-logo.png', // Path to your logo
                height: 30, // Adjust the height as needed
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: WorkoutscheduleWidget(),
        ),
      ),
    );
  }
}
