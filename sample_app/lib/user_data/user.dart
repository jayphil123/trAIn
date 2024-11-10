class User {
  final String username,
  final String password,
  final String full_name;
  final String gender;
  final double height; // in centimeters
  final double weight; // in kilograms
  final String profilePictureUrl;
  final WorkoutSplit workoutSplit;

  User({
    required this.full_name,
    required this.gender,
    required this.height,
    required this.weight,
    required this.profilePictureUrl,
    required this.workoutSplit,
  });

  @override
  String toString() {
    return 'User(name: $full_name, gender: $gender, height: $height cm, weight: $weight kg, profilePictureUrl: $profilePictureUrl, workoutSplit: $workoutSplit)';
  }
}

class WorkoutSplit {
  final Map<String, List<String>> exercisesPerDay;

  WorkoutSplit({required this.exercisesPerDay});

  // Function to display workouts for a specific day
  List<String> getWorkoutForDay(String day) {
    return exercisesPerDay[day] ?? [];
  }

  @override
  String toString() {
    return exercisesPerDay.toString();
  }
}
