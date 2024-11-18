import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo Image
              Container(
                padding: const EdgeInsets.only(top: 70, bottom: 32),
                child: Image.asset(
                  'assets/images/train-white-logo.png',
                  width: 120,
                  height: 120,
                ),
              ),
              // Title Text
              Text(
                'Reimagine your workout regime',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Text(
                'Join the future of personalized workouts',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Password Field
              TextField(
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 16),
              // Sign In Button
              ElevatedButton(
                onPressed: () async {
                  bool login = await validLogin(context);
                  if (login) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              const SplashScreen(fromLogin: true,)),
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            const SignUpPage1()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up here",
                  // style: TextStyle(color: Theme.of(context).primaryColor),
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
  final response = await loginRequest(emailController.text, passwordController.text);

  print(response);

  if (response["status"] == 0) {
    final formData = Provider.of<FormDataProvider>(context, listen: false).formData;

    formData.username = response["user_info"][1];
    formData.password = "";
    formData.name = response["user_info"][3];
    formData.height = response["user_info"][4];
    formData.weight = response["user_info"][5];
    formData.gender = response["user_info"][6];
    formData.age = response["user_info"][7];
    formData.goals = List<String>.from(response["user_info"][8].map((item) => item.toString()));
    formData.frequency = List<String>.from(response["user_info"][9].map((item) => item.toString()));
    formData.intensity = List<String>.from(response["user_info"][10].map((item) => item.toString()));
    formData.timeframe = List<String>.from(response["user_info"][11].map((item) => item.toString()));
    formData.workoutPlans = response["user_info"][12];

    return true;
  } else {
    return false;
  }
}