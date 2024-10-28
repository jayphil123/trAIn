import 'package:flutter/material.dart';

class SampleWorkoutWidget extends StatefulWidget {
  const SampleWorkoutWidget({super.key});

  @override
  State<SampleWorkoutWidget> createState() => _SampleWorkoutWidgetState();
}

class _SampleWorkoutWidgetState extends State<SampleWorkoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text('Chest & Triceps'),
                  Text('Estimated time: 60 minutes'),
                ],
              ),
              Icon(
                Icons.fitness_center,
                size: 32,
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
                  Text('4 sets x 8-10 reps'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Incline Dumbbell Press'),
                  Text('3 sets x 10-12 reps'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cable Flyes'),
                  Text('3 sets x 12-15 reps'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tricep Pushdowns'),
                  Text('3 sets x 12-15 reps'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Skullcrushers'),
                  Text('3 sets x 10-12 reps'),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              print('Button pressed ...');
            },
            child: Text('Start Workout'),
          ),
        ],
      ),
    );
  }
}
