import 'package:flutter/material.dart';

class WorkoutPreview extends StatelessWidget {
  final String day;
  final String workoutType;
  final IconData icon;
  final VoidCallback onTap;

  const WorkoutPreview({
    Key? key,
    required this.day,
    required this.workoutType,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      workoutType,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Icon(
                  icon,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
