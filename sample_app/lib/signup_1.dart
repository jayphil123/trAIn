import 'package:flutter/material.dart';

class SignUp2Widget extends StatefulWidget {
  const SignUp2Widget({super.key});

  @override
  State<SignUp2Widget> createState() => _SignUp2WidgetState();
}

class _SignUp2WidgetState extends State<SignUp2Widget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final textController = TextEditingController();
  bool passwordVisible = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title Text
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Text(
                    'Begin your workout journey with us!',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Input Field for First Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter your first name',
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: textController,
                                decoration: const InputDecoration(
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                    fontFamily: 'HelveticaNeue',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                style: const TextStyle(
                                  fontFamily: 'HelveticaNeue',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                print('Proceed button pressed');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Logo Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/train-white-logo.png',
                    width: 120,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
