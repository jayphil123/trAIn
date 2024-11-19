import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'signup_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> getWorkout(String query, int count) async {
  // final url = Uri.parse('http://localhost:5000/get_workout?query=$query&count=$count');
  final url = dotenv.get('AWS_API_URL');

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Success! Parse the response if it returns JSON.
      final workoutData = json.decode(response.body);
      print(workoutData);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> sendFormDataToServer(BuildContext context) async {
  try {
    // Access the FormDataProvider to get data
    final formData =
        Provider.of<FormDataProvider>(context, listen: false).formData;

    // Create the payload to send
    String goals = formData.goals.join(" ");
    String frequency = formData.frequency.join(" ");
    String intensity = formData.intensity.join(" ");
    String timeframe = formData.timeframe.join(" ");
    String plans = formData.workoutPlans;
    String newPayload =
        "My goals for training are to $goals, I want to work out $frequency, ";
    newPayload +=
        "I want an intensity level of $intensity and I plan to workout for $timeframe. ";
    newPayload +=
        "Here is some more information about my workout goals: $plans.";

    print(newPayload);

    // // Define the URL of your server
    final url = Uri.parse(
        'http://localhost:5000/send_convo?query=$newPayload'); // Replace with your server URL

    // Send the HTTP POST request
    final response = await http.get(url);
    // print(json.decode(response.body));

    Map<String, dynamic> responseMap = json.decode(response.body);
    updateWorkouts(responseMap, context);
  } catch (e) {
    // Handle errors
    print('Error occurred: $e');
  }
}

Future<String> chatMessage(BuildContext context, String msg) async {
  final workoutProvider =
      Provider.of<WorkoutSplitProvider>(context, listen: false);
  String payload = msg;
  payload += 'Here is my current workout';

  String alterWorkout = jsonEncode({
    "monday": workoutProvider.workoutSplit.monday,
    "tuesday": workoutProvider.workoutSplit.tuesday,
    "wednesday": workoutProvider.workoutSplit.wednesday,
    "thursday": workoutProvider.workoutSplit.thursday,
    "friday": workoutProvider.workoutSplit.friday,
    "saturday": workoutProvider.workoutSplit.saturday,
    "sunday": workoutProvider.workoutSplit.sunday,
  });

  // Construct the URL with query parameters
  final url = Uri.parse(
    'http://localhost:5000/send_convo'
    '?query=$payload'
    '&existing_workout=${Uri.encodeComponent(alterWorkout)}',
  );

  // Send and recieve the message
  final response = await http.get(url);
  final responseParsed = json.decode(response.body);

  print(responseParsed["status"]);
  if (responseParsed["status"] == 2 || responseParsed["status"] == 1) {
    updateWorkouts(responseParsed, context);
    String thing = formatWorkoutSplit(responseParsed);
    print(thing);

    return thing;
  } else {
    return responseParsed["content"];
  }

  // print(json.decode(response.body));
}

Future<void> sendSignUpDataToBackend(BuildContext context) async {
  final formData =
      Provider.of<FormDataProvider>(context, listen: false).formData;

  final url = Uri.parse(
      'http://localhost:5000//signup_form'); // Replace with your server URL

  // Prepare the data to send
  final Map<String, dynamic> userInfo = {
    'username': formData.username,
    'password': formData.password,
    'name': formData.name,
    'height': formData.height, // height in centimeters
    'weight': formData.weight, // weight in kilograms
    'gender': formData.gender,
    'age': formData.age,
    'goals': formData.goals, // list of goals
    'frequency': formData.frequency, // list of workout frequency
    'intensity': formData.intensity, // list of workout intensity
    'timeframe': formData.timeframe, // list of timeframes for achieving goals
    'workoutplans': formData.workoutPlans, // user’s preferred workout plan
  };

  // Make the POST request
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(userInfo),
  );

  // Check the response status
  if (response.statusCode == 200) {
    print('User created successfully');
    print('Response body: ${response.body}');
  } else if (response.statusCode == 400) {
    print('Error: ${response.body}');
  } else {
    print('Unexpected error: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> loginRequest(
    String username, String password) async {
  final uri = Uri.parse(
      "http://127.0.0.1:5000/login_form?username=$username&password=$password");

  final response = await http.post(
    uri,
  );

  final responseParsed = json.decode(response.body);
  return responseParsed;
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

  // Check if 'content' is a Map<String, dynamic>
  if (workoutSplit["content"] is Map<String, dynamic>) {
    Map<String, dynamic> workouts = workoutSplit["content"];

    for (String day in days) {
      if (workouts[day] is List) {
        // Cast to List<Map<String, dynamic>> after verifying it's a List
        List<Map<String, dynamic>> new_day =
            List<Map<String, dynamic>>.from(workouts[day]);
        formattedSplit += "$day: ";
        for (Map<String, dynamic> workout in new_day) {
          formattedSplit += "${workout["workout"]} ";
        }
        formattedSplit = formattedSplit.substring(
            0, formattedSplit.length - 1); // Remove trailing space
        formattedSplit += "\n";
      }
    }
  } else {
    print("Error: 'content' is not a Map.");
  }

  return formattedSplit;
}

void updateWorkouts(final oldSplit, BuildContext context) {
  List<Map<String, dynamic>> mondayWorkouts =
      List<Map<String, dynamic>>.from(oldSplit['content']['monday']);
  List<Map<String, dynamic>> tuesdayWorkouts =
      List<Map<String, dynamic>>.from(oldSplit['content']['tuesday']);
  List<Map<String, dynamic>> wednesdayWorkouts =
      List<Map<String, dynamic>>.from(oldSplit['content']['wednesday']);
  List<Map<String, dynamic>> thursdayWorkouts =
      List<Map<String, dynamic>>.from(oldSplit['content']['thursday']);
  List<Map<String, dynamic>> fridayWorkouts =
      List<Map<String, dynamic>>.from(oldSplit['content']['friday']);
  List<Map<String, dynamic>> saturdayWorkouts =
      List<Map<String, dynamic>>.from(oldSplit['content']['saturday']);
  List<Map<String, dynamic>> sundayWorkouts =
      List<Map<String, dynamic>>.from(oldSplit['content']['sunday']);

  Provider.of<WorkoutSplitProvider>(context, listen: false)
      .updateMonday(mondayWorkouts);
  Provider.of<WorkoutSplitProvider>(context, listen: false)
      .updateTuesday(tuesdayWorkouts);
  Provider.of<WorkoutSplitProvider>(context, listen: false)
      .updateWednesday(wednesdayWorkouts);
  Provider.of<WorkoutSplitProvider>(context, listen: false)
      .updateThursday(thursdayWorkouts);
  Provider.of<WorkoutSplitProvider>(context, listen: false)
      .updateFriday(fridayWorkouts);
  Provider.of<WorkoutSplitProvider>(context, listen: false)
      .updateSaturday(saturdayWorkouts);
  Provider.of<WorkoutSplitProvider>(context, listen: false)
      .updateSunday(sundayWorkouts);
}
