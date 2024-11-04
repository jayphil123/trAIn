import 'package:flutter/material.dart';
import 'package:train_app/theme.dart';

class SampleWorkoutWidget extends StatefulWidget {
  const SampleWorkoutWidget({super.key});

  @override
  State<SampleWorkoutWidget> createState() => _SampleWorkoutWidgetState();
}

class _SampleWorkoutWidgetState extends State<SampleWorkoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground, // Background color
        borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
      ),
      padding: EdgeInsets.all(16.0),
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
                  Text('Chest & Triceps',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: AppTheme.primaryText),),
                  Text('Estimated time: 60 minutes',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.secondBackground),),
                ],
              ),
              Icon(
                Icons.fitness_center,
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          Divider(thickness: 1),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bench Press'),
                  Text('4 sets x 8-10 reps',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.secondBackground)
                      ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Incline Dumbbell Press'),
                  Text('3 sets x 10-12 reps',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.secondBackground)
                      ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cable Flyes'),
                  Text('3 sets x 12-15 reps',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.secondBackground)
                      ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tricep Pushdowns'),
                  Text('3 sets x 12-15 reps',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.secondBackground)
                      ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Skullcrushers'),
                  Text('3 sets x 10-12 reps',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.secondBackground)
                      ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0), // Adjust the top padding as needed
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // Set width and height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
                ),
              ),
              onPressed: () {
                print('Button pressed ...');
              },
              child: Text('Start Workout',
                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.primaryText)),
            ),
          ),
        ],
      ),
    );
  }
}
