import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'signup_info.dart';
import 'package:flutter/material.dart';

Future<void> getWorkout(String query, int count) async {
  final url = Uri.parse('http://localhost:5000/get_workout?query=$query&count=$count');

  try {
    final response = await http.get(url);

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

// Function to send the form data over HTTP
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
    print(json.decode(response.body));

    // // Handle the response
    // if (response.statusCode == 200) {
    //   // Successful response
    //   print('Data sent successfully!');
    // } else {
    //   // Failure response
    //   print('Failed to send data. Status Code: ${response.statusCode}');
    // }
  } catch (e) {
    // Handle errors
    print('Error occurred: $e');
  }
}
