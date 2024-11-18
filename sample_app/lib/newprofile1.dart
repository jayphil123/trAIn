import 'package:flutter/material.dart';
import 'newprofile2.dart' show NewProfilePage2;
import 'package:provider/provider.dart';
import 'user_data/signup_info.dart';
import 'theme.dart';

class NewProfilePage1 extends StatefulWidget {
  const NewProfilePage1({Key? key}) : super(key: key);

  @override
  State<NewProfilePage1> createState() => _NewProfilePage1State();
}

class _NewProfilePage1State extends State<NewProfilePage1> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  final textController3 = TextEditingController();
  final textController4 = TextEditingController();

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    textController3.dispose();
    textController4.dispose();
    super.dispose();
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
                const SizedBox(height: 8),
                _buildInputField(
                  controller: textController1,
                  labelText: 'Enter your height',
                  hintText: 'Height',
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: textController2,
                  labelText: 'Enter your weight',
                  hintText: 'Weight',
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: textController3,
                  labelText: 'Enter your gender',
                  hintText: 'Gender',
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: textController4,
                  labelText: 'Enter your age',
                  hintText: 'Age',
                ),
                const SizedBox(height: 30),
                // Elevated Button (Purple button)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: ElevatedButton(
                    onPressed: () {
                      // Update form data before navigating
                      Provider.of<FormDataProvider>(context, listen: false)
                        .updateHeight(textController1.text);
                      Provider.of<FormDataProvider>(context, listen: false)
                        .updateWeight(textController2.text);
                      Provider.of<FormDataProvider>(context, listen: false)
                        .updateGender(textController3.text);
                      Provider.of<FormDataProvider>(context, listen: false)
                        .updateAge(textController4.text);

                      // Navigate to the next page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NewProfilePage2(),
                        ),
                      );
                    },
                    child: const Text('Next'),
                  ),
                ),
                const SizedBox(height: 12), // Spacing after button

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

  // Helper method for text fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 14, // Set label text size to 14
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppTheme.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
