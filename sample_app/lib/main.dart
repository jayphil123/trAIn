import 'dart:async';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'login.dart';
import 'login.dart' show LoginPage;
import 'package:provider/provider.dart';
import 'user_data/signup_info.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FormDataProvider(),
      child: const StartPage(),
    ),
  );
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'trAIn Fitness App',
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 70, bottom: 32),
              child: Image.asset(
                'assets/images/train-white-logo.png',
                width: 120,
                height: 120,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to trAIn',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
          ],
        ),
      ),
    );
  }
}
