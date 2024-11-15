import 'package:flutter/material.dart';
import 'user.dart';

String formatMuscleGroups(List<Map<String, dynamic>> data) { 
  // Step 1: Extract primary_muscles into a Set
  Set<String> uniquePrimaryMuscles = {};
  for (var workout in data) {
    if (workout.containsKey('primary_muscles')) {
      // Capitalize the first letter of the muscle group
      String muscleGroup = workout['primary_muscles'];

      // Replace "quadriceps" with "Quads" and "Abdominals" with "Abs"
      if (muscleGroup.toLowerCase() == 'quadriceps') {
        muscleGroup = 'quads';
      } else if (muscleGroup.toLowerCase() == 'abdominals') {
        muscleGroup = 'abs';
      }

      // Capitalize the first letter of the muscle group if it's not already handled
      String capitalizedMuscleGroup = muscleGroup[0].toUpperCase() + muscleGroup.substring(1);
      uniquePrimaryMuscles.add(capitalizedMuscleGroup);
    }
  }

  // Step 2: Convert the Set to a List
  List<String> list = uniquePrimaryMuscles.toList();

  // Step 3: Format the List into a string
  if (list.isEmpty) {
    return 'Rest'; // Handle the empty case
  } else if (list.length == 1) {
    return list.first; // Single element case
  } else if (list.length == 2) {
    return '${list[0]} and ${list[1]}'; // Two elements case
  } else {
    // More than two elements case
    String allButLast = list.sublist(0, list.length - 1).join(', ');
    return '$allButLast, and ${list.last}';
  }
}



class FormData {
  String username;
  String password;
  String name;
  String height;
  String weight;
  String gender;
  String age;
  List<String> goals;
  List<String> frequency;
  List<String> intensity;
  List<String> timeframe;
  String workoutPlans;

  FormData({
    this.username = '',
    this.password = '',
    this.name = '',
    this.height = '',
    this.weight = '',
    this.gender = '',
    this.age = '',
    this.goals = const [],
    this.frequency = const [],
    this.intensity = const [],
    this.timeframe = const [],
    this.workoutPlans = '',
  });
}

class FormDataProvider with ChangeNotifier {
  FormData _formData = FormData();

  FormData get formData => _formData;

  void updateUsername(String data) {
    _formData.username = data;
    notifyListeners();
  }

  void updatePassword(String data) {
    _formData.password = data;
    notifyListeners();
  }

  void updateName(String data) {
    _formData.name = data;
    notifyListeners();
  }

  void updateHeight(String data) {
    _formData.height = data;
    notifyListeners();
  }

  void updateWeight(String data) {
    _formData.weight = data;
    notifyListeners();
  }

  void updateGender(String data) {
    _formData.gender = data;
    notifyListeners();
  }

  void updateAge(String data) {
    _formData.age = data;
    notifyListeners();
  }

  void updateGoals(List<String> data) {
    _formData.goals = data;
    notifyListeners();
  }

  void updateFrequency(List<String> data) {
    _formData.frequency = data;
    notifyListeners();
  }

  void updateIntensity(List<String> data) {
    _formData.intensity = data;
    notifyListeners();
  }

  void updateTimeframe(List<String> data) {
    _formData.timeframe = data;
    notifyListeners();
  }

  void updateWorkoutPlans(String data) {
    _formData.workoutPlans = data;
    notifyListeners();
  }
}

class WorkoutSplitProvider with ChangeNotifier {
  WorkoutSplit _workoutSplit = WorkoutSplit();

  WorkoutSplit get workoutSplit => _workoutSplit;

  void updateMonday(List<Map<String, dynamic>> data) {
    _workoutSplit.monday = data;
  _workoutSplit.mondayMuscles = formatMuscleGroups(data);
    notifyListeners();
  }

  void updateTuesday(List<Map<String, dynamic>> data) {
    _workoutSplit.tuesday = data;
  _workoutSplit.tuesdayMuscles = formatMuscleGroups(data);
    notifyListeners();
  }

  void updateWednesday(List<Map<String, dynamic>> data) {
    _workoutSplit.wednesday = data;
  _workoutSplit.wednesdayMuscles = formatMuscleGroups(data);
    notifyListeners();
  }

  void updateThursday(List<Map<String, dynamic>> data) {
    _workoutSplit.thursday = data;
  _workoutSplit.thursdayMuscles = formatMuscleGroups(data);
    notifyListeners();
  }

  void updateFriday(List<Map<String, dynamic>> data) {
    _workoutSplit.friday = data;
  _workoutSplit.fridayMuscles = formatMuscleGroups(data);
    notifyListeners();
  }

  void updateSaturday(List<Map<String, dynamic>> data) {
    _workoutSplit.saturday = data;
  _workoutSplit.saturdayMuscles = formatMuscleGroups(data);
    notifyListeners();
  }

  void updateSunday(List<Map<String, dynamic>> data) {
    _workoutSplit.sunday = data;
  _workoutSplit.sundayMuscles = formatMuscleGroups(data);
    notifyListeners();
  }
}