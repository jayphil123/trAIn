import 'package:flutter/material.dart';
import 'newprofile3.dart' show NewProfilePage3;

class NewProfilePage2 extends StatefulWidget {
  const NewProfilePage2({super.key});

  @override
  State<NewProfilePage2> createState() => _NewProfilePage2State();
}

class _NewProfilePage2State extends State<NewProfilePage2> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> selectedFitnessGoals = [];
  final List<String> selectedFrequency = [];

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 22, bottom: 12),
                          child: Text(
                            'Create your personalized profile',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCheckboxGroup(
                          title: 'What are your primary fitness goals?',
                          options: [
                            'Build Muscle',
                            'Lose Weight',
                            'Improve Endurance',
                            'Enhance Flexibility',
                            'Increase Strength',
                            'General Wellness',
                            'Other'
                          ],
                          selectedOptions: selectedFitnessGoals,
                        ),
                        const SizedBox(height: 20),
                        _buildCheckboxGroup(
                          title: 'How often do you want to train?',
                          options: [
                            '1-2 times',
                            '3-4 times',
                            '5-6 times',
                            'Daily',
                          ],
                          selectedOptions: selectedFrequency,
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
                                        const NewProfilePage3()),
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

  // Helper method to create a checkbox group
  Widget _buildCheckboxGroup({
    required String title,
    required List<String> options,
    required List<String> selectedOptions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...options.map((option) {
          return CheckboxListTile(
            value: selectedOptions.contains(option),
            title: Text(option, style: Theme.of(context).textTheme.bodyLarge),
            onChanged: (isSelected) {
              setState(() {
                isSelected!
                    ? selectedOptions.add(option)
                    : selectedOptions.remove(option);
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, // Moves checkbox to the left
          );
        }).toList(),
      ],
    );
  }
}
