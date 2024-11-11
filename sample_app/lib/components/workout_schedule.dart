import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'workout_preview.dart';
import 'workout.dart'; // Import the Workout model
import 'sample_workout.dart' show SampleWorkoutWidget;
import 'package:intl/intl.dart';

String getDate() {
  final DateTime now = DateTime.now();
  
  // Calculate the difference to Monday (1) based on the current weekday
  final int daysToSubtract = now.weekday - DateTime.monday;
  final DateTime monday = now.subtract(Duration(days: daysToSubtract));
  
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  return formatter.format(monday);
}

class WorkoutscheduleWidget extends StatefulWidget {
  const WorkoutscheduleWidget({super.key});

  @override
  State<WorkoutscheduleWidget> createState() => _WorkoutscheduleWidgetState();
}

class _WorkoutscheduleWidgetState extends State<WorkoutscheduleWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Workout> workouts = []; // Store parsed workouts

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  // Simulate loading workouts from JSON data
  Future<void> _loadWorkouts() async {
    const jsonData = '''
      {
        "workouts": [
          { "day": "Monday", "workoutType": "Upper Body Strength", "icon": "fitness_center" },
          { "day": "Tuesday", "workoutType": "Lower Body Strength", "icon": "fitness_center" },
          { "day": "Wednesday", "workoutType": "Yoga and Mobility", "icon": "self_improvement" },
          { "day": "Thursday", "workoutType": "Push Day (Chest, Shoulders)", "icon": "fitness_center" },
          { "day": "Friday", "workoutType": "Pull Day (Back, Biceps)", "icon": "fitness_center" },
          { "day": "Saturday", "workoutType": "Full Body HIIT", "icon": "directions_run" },
          { "day": "Sunday", "workoutType": "Active Recovery (Cardio, Stretching)", "icon": "bed" }
        ]

      }
    ''';

    // Decode JSON data and parse into Workout objects
    final data = json.decode(jsonData) as Map<String, dynamic>;
    final workoutsList = data['workouts'] as List;
    setState(() {
      workouts = workoutsList.map((json) => Workout.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: const Color(0x33000000),
              offset: const Offset(0, 2),
              spreadRadius: 0,
            )
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Training - ${getDate()}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return WorkoutPreview(
                    day: workout.day,
                    workoutType: workout.workoutType,
                    icon: workout.icon,
                    onTap: () {
                      _showWorkoutDetails(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkoutDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: const SampleWorkoutWidget(),
          ),
        );
      },
    );
  }
}
