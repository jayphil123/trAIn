import 'package:flutter/material.dart';
import 'newprofile2.dart' show NewProfilePage2;

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 22),
                          child: Text(
                            'Create your personalized profile',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Help us understand yourself as a user',
                            style: TextStyle(
                              fontSize: 16,
                              // color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NewProfilePage2()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Image(
                    image: AssetImage('assets/images/train-white-logo.png'),
                    width: 120,
                    height: 60,
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
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
