import 'package:flutter/material.dart';
import 'package:train_app/newprofile1.dart';
import 'newprofile1.dart' show NewProfilePage1;
import 'user_data/talk.dart';
import 'theme.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});

  @override
  State<SignUpPage1> createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool passwordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    await sendSignUpDataToBackend(context, firstName, lastName, username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: AppTheme.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    const Text(
                      'Create your trAIn workout profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Set up a basic account to get started',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

                // Full Name Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter your full name',
                          style: TextStyle(
                            color: AppTheme.primaryText,
                            fontSize: 14, 
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.secondaryText
                                  ),
                                  border: InputBorder.none,
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.secondaryText
                                  ),
                                  border: InputBorder.none,
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Username Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 16), // 32px spacing
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create an username',
                          style: TextStyle(
                            color: AppTheme.primaryText,
                            fontSize: 14, 
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.secondaryText
                                  ),
                                  border: InputBorder.none,
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Password Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create a password',
                          style: TextStyle(
                            color: AppTheme.primaryText,
                            fontSize: 14, 
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: !passwordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.secondaryText
                                  ),
                                  border: InputBorder.none,
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Next Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: ElevatedButton(
                    onPressed: () {
                      _onSubmit(); 
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NewProfilePage1(),
                        ),
                      );
                    },
                    child: const Text('Next'),
                  ),
                ),
                const SizedBox(height: 12),

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