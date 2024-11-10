import 'package:flutter/material.dart';

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