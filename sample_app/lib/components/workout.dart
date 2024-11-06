import 'package:flutter/material.dart';

class Workout {
  final String day;
  final String workoutType;
  final IconData icon;

  Workout({
    required this.day,
    required this.workoutType,
    required this.icon,
  });

  // Factory method to create a Workout from JSON data
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      day: json['day'] as String,
      workoutType: json['workoutType'] as String,
      icon: _getIconFromName(json['icon'] as String),
    );
  }

  // Helper method to get an IconData from a string name
  static IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'fitness_center':
        return Icons.fitness_center;
      case 'bed':
        return Icons.bed;
      case 'directions_run':
        return Icons.directions_run;
      default:
        return Icons.help; // default icon if not found
    }
  }
}
