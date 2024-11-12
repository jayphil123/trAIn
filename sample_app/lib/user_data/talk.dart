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
    final formData = Provider.of<FormDataProvider>(context, listen: false).formData;

    // Create the payload to send
    String goals = formData.goals.join(" ");
    String frequency = formData.frequency.join(" ");
    String intensity = formData.intensity.join(" ");
    String timeframe = formData.timeframe.join(" ");
    String plans = formData.workoutPlans;
    String newPayload = "My goals for training are to $goals, I want to work out $frequency, ";
    newPayload += "I want an intensity level of $intensity and I plan to workout for $timeframe. ";
    newPayload += "Here is some more information about my workout goals: $plans.";

    print(newPayload);

    // // Define the URL of your server
    final url = Uri.parse('http://localhost:5000/send_convo?query=$newPayload'); // Replace with your server URL

    // Send the HTTP POST request
    final response = await http.get(url);
    // print(json.decode(response.body));

    Map<String, dynamic> responseMap = json.decode(response.body);
    List<Map<String, dynamic>> mondayWorkouts = List<Map<String, dynamic>>.from(responseMap['content']['monday']);
    List<Map<String, dynamic>> tuesdayWorkouts = List<Map<String, dynamic>>.from(responseMap['content']['tuesday']);
    List<Map<String, dynamic>> wednesdayWorkouts = List<Map<String, dynamic>>.from(responseMap['content']['wednesday']);
    List<Map<String, dynamic>> thursdayWorkouts = List<Map<String, dynamic>>.from(responseMap['content']['thursday']);
    List<Map<String, dynamic>> fridayWorkouts = List<Map<String, dynamic>>.from(responseMap['content']['friday']);
    List<Map<String, dynamic>> saturdayWorkouts = List<Map<String, dynamic>>.from(responseMap['content']['saturday']);
    List<Map<String, dynamic>> sundayWorkouts = List<Map<String, dynamic>>.from(responseMap['content']['sunday']);

    Provider.of<WorkoutSplitProvider>(context, listen: false).updateMonday(mondayWorkouts);
    Provider.of<WorkoutSplitProvider>(context, listen: false).updateTuesday(tuesdayWorkouts);
    Provider.of<WorkoutSplitProvider>(context, listen: false).updateWednesday(wednesdayWorkouts);
    Provider.of<WorkoutSplitProvider>(context, listen: false).updateThursday(thursdayWorkouts);
    Provider.of<WorkoutSplitProvider>(context, listen: false).updateFriday(fridayWorkouts);
    Provider.of<WorkoutSplitProvider>(context, listen: false).updateSaturday(saturdayWorkouts);
    Provider.of<WorkoutSplitProvider>(context, listen: false).updateSunday(sundayWorkouts);


  } catch (e) {
    // Handle errors
    print('Error occurred: $e');
  }
}

Future<void> sendSignUpDataToBackend(BuildContext context, String firstName, String lastName, String username, String password) async {
  try {
    final payload = {
      'full_name': "$firstName $lastName",
      'username': username,
      'password': password,
    };

    print(payload); 

    // Commented this out for now since it doesn't work

    // Define the URL of your AWS instance endpoint
    // final url = Uri.parse('http://localhost:5000/get_workout?query=$query&count=$count');
    // // final url = dotenv.get('AWS_API_URL');


    // final response = await http.post(
    //   Uri.parse(url),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(payload), // convert payload to json
    // );

    // if (response.statusCode == 200) {
    //   print('Data sent successfully!');
    // } else {
    //   // error
    //   print('Failed to send data. Status Code: ${response.statusCode}');
    // }
  } catch (e) {
    //  errors
    print('Error occurred: $e');
  }
}