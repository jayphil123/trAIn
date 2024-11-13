import 'package:flutter/material.dart';
import 'package:train_app/theme.dart';

class SampleWorkoutWidget extends StatelessWidget {
  final List<MapEntry<String, String>> workouts;
  final String workoutType;

  const SampleWorkoutWidget({
    super.key,
    required this.workouts,
    required this.workoutType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground, // Background color
        borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutType,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  Text(
                    'Estimated time: ${workouts.length * 15} minutes', // Approximation based on number of workouts
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.secondBackground,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.fitness_center,
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          const Divider(thickness: 1),
          // Dynamically display workout rows
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              workouts.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      workouts[index].key,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    Text(
                      workouts[index].value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onPressed: () {
                print('Start $workoutType Workout');
              },
              child: Text(
                'Start Workout',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
