import 'package:flutter/material.dart';
import 'signup1.dart' show SignUpPage1;
import 'theme.dart';
import 'user_data/talk.dart';
import 'signup_load.dart';
import 'package:provider/provider.dart';
import 'user_data/signup_info.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          padding: AppTheme.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Ensures Column takes up only as much space as needed
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 18),
                child: Image.asset(
                  'assets/images/train-white-logo.png',
                  width: 120,
                  height: 120,
                ),
              ),

              Text(
                'Reimagine your workout regime',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryText),
              ),
              const SizedBox(height: 8),
              Container(
                width: 212,
                child: Text(
                  'Join the future of personalized workouts with trAIn',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppTheme.secondaryText),
                ),
              ),
              const SizedBox(height: 22),
              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: InputBorder.none,
                  filled: true,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Password Field
              TextField(
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 72),
              ElevatedButton(
                onPressed: () async {
                  bool login = await validLogin(context);
                  if (login) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen(
                                fromLogin: true,
                              )),
                    );
                  } else {
                    // TODO add something to indicate failed login
                  }
                },
                child: Text('Sign In'),
              ),
              const SizedBox(height: 12),
              // Sign Up Link
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage1(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: AppTheme.primaryText,
                    ),
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                      ),
                      TextSpan(
                        text: "Sign Up here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> validLogin(BuildContext context) async {
  final response =
      await loginRequest(emailController.text, passwordController.text);

  print(response);

  if (response["status"] == 0) {
    final formData =
        Provider.of<FormDataProvider>(context, listen: false).formData;

    formData.username = response["user_info"][1];
    formData.password = "";
    formData.name = response["user_info"][3];
    formData.height = response["user_info"][4];
    formData.weight = response["user_info"][5];
    formData.gender = response["user_info"][6];
    formData.age = response["user_info"][7];
    formData.goals = List<String>.from(
        response["user_info"][8].map((item) => item.toString()));
    formData.frequency = List<String>.from(
        response["user_info"][9].map((item) => item.toString()));
    formData.intensity = List<String>.from(
        response["user_info"][10].map((item) => item.toString()));
    formData.timeframe = List<String>.from(
        response["user_info"][11].map((item) => item.toString()));
    formData.workoutPlans = response["user_info"][12];

    return true;
  } else {
    return false;
  }
}
