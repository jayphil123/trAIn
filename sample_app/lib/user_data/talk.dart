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

Future<void> sendFormDataToServer(BuildContext context) async {
  try {
    // Access the FormDataProvider to get data
    final formData = Provider.of<FormDataProvider>(context, listen: false).formData;

    // Create the payload to send
    final payload = {
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


  } catch (e) {
    // Handle errors
    print('Error occurred: $e');
  }
}

Future<void> sendSignUpDataToBackend(BuildContext context, String firstName, String lastName, String username, String password) async {
  try {
    final payload = {
      'full_name': full_name,
      'username': username,
      'password': password,
    };

    print(payload); 

    // Define the URL of your AWS instance endpoint
    // final url = Uri.parse('http://localhost:5000/get_workout?query=$query&count=$count');
    final url = dotenv.get('AWS_API_URL');


    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload), // convert payload to json
    );

    if (response.statusCode == 200) {
      print('Data sent successfully!');
    } else {
      // error
      print('Failed to send data. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    //  errors
    print('Error occurred: $e');
  }
}