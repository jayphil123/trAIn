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
          title: Text("Welcome, [USER]"),
        ),
        body: SafeArea(
          child: WorkoutscheduleWidget(),
        ),
      ),
    );
  }
}
