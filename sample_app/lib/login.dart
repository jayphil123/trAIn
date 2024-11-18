import 'package:flutter/material.dart';
import 'signup1.dart' show SignUpPage1;
import 'homepage.dart' show HomepageWidget;
import 'theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          padding: AppTheme.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensures Column takes up only as much space as needed
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
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryText),
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
                  hintText: 'Email',
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const HomepageWidget()),
                  );
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
