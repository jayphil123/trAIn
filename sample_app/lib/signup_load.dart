import 'package:flutter/material.dart';
import 'user_data/talk.dart';
import 'homepage.dart';

Future<void> _initializePage(context) async {
  await sendFormDataToServer(context);
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const HomepageWidget()),
  );
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
    _initializePage(context);
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
              'Loading your AI workout',
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
