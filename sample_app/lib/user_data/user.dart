class User {
  final String username;
  final String password;
  final String fullName;
  final String gender;
  final double height; // in centimeters
  final double weight; // in kilograms
  final String profilePictureUrl;
  final WorkoutSplit workoutSplit;

  User({
    required this.username,
    required this.password,
    required this.fullName,
    required this.gender,
    required this.height,
    required this.weight,
    required this.profilePictureUrl,
    required this.workoutSplit,
  });

  @override
  String toString() {
    return 'User(name: $fullName, gender: $gender, height: $height cm, weight: $weight kg, profilePictureUrl: $profilePictureUrl, workoutSplit: $workoutSplit)';
  }
}

class WorkoutSplit {
  // Each day of the week is represented as a list of maps
  // Each map represents an exercise with properties like name, sets, and reps
  List<Map<String, dynamic>> monday = [];
  List<Map<String, dynamic>> tuesday = [];
  List<Map<String, dynamic>> wednesday = [];
  List<Map<String, dynamic>> thursday = [];
  List<Map<String, dynamic>> friday = [];
  List<Map<String, dynamic>> saturday = [];
  List<Map<String, dynamic>> sunday = [];
  String mondayMuscles = "";
  String tuesdayMuscles = "";
  String wednesdayMuscles = "";
  String thursdayMuscles = "";
  String fridayMuscles = "";
  String saturdayMuscles = "";
  String sundayMuscles = "";

  WorkoutSplit({
    this.monday = const [],
    this.tuesday = const [],
    this.wednesday = const [],
    this.thursday = const [],
    this.friday = const [],
    this.saturday = const [],
    this.sunday = const [],
  this.mondayMuscles = '',
  this.tuesdayMuscles = '',
  this.wednesdayMuscles = '',
  this.thursdayMuscles = '',
  this.fridayMuscles = '',
  this.saturdayMuscles = '',
  this.sundayMuscles = '',
  });

    // Function to get the workout list for a given day
  List<Map<String, dynamic>> getDay(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return monday;
      case 'tuesday':
        return tuesday;
      case 'wednesday':
        return wednesday;
      case 'thursday':
        return thursday;
      case 'friday':
        return friday;
      case 'saturday':
        return saturday;
      case 'sunday':
        return sunday;
      default:
        return []; // Return an empty list if the day is invalid
    }
  }
}

List<MapEntry<String, String>> accessWorkouts(List<Map<String, dynamic>> day) {
  List<MapEntry<String, String>> workouts = [];

  for (var workout in day) {
    String workoutName = workout['workout'] ?? 'Unknown Workout';
    String quantity = workout['quantity'] ?? 'Unknown Quantity';

    // Modify the quantity format if it contains "sets" and "reps"
    if (quantity.contains('sets') && quantity.contains('reps')) {
      quantity = quantity
          .replaceAll('sets of', 'x')
          .replaceAll(' reps', '')
          .replaceAll('of ', '');
          // .replaceAll(' ', ' x ');
    }

    workouts.add(MapEntry(workoutName, quantity));
  }

  return workouts;
}
