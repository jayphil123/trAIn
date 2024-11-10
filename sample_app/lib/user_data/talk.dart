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
    final payload = {
      'name': formData.name,
      'height': formData.height,
      'weight': formData.weight,
      'gender': formData.gender,
      'age': formData.age,
      'goals': formData.goals,
      'frequency': formData.frequency,
      'intensity': formData.intensity,
      'timeframe': formData.timeframe,
      'workoutPlans': formData.workoutPlans,
    };

    print(payload);

    // // Define the URL of your server
    // final url = Uri.parse('https://yourapi.com/submit'); // Replace with your server URL

    // // Send the HTTP POST request
    // final response = await http.post(
    //   url,
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(payload), // Convert the payload to JSON
    // );

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
