import 'package:flutter/material.dart';
import 'signup.dart' show SignUp2Widget;

class SignUp1Widget extends StatefulWidget {
  const SignUp1Widget({super.key});

  @override
  State<SignUp1Widget> createState() => _SignUp1WidgetState();
}

class _SignUp1WidgetState extends State<SignUp1Widget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
                  labelText: 'Email',
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
                onPressed: () {
                  // Add your sign-in logic here
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 12),
              // Sign Up Link
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const SignUp2Widget()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up here",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
