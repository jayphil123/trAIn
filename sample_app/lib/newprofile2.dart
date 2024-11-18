import 'package:flutter/material.dart';
import 'newprofile3.dart' show NewProfilePage3;
import 'package:provider/provider.dart';
import 'user_data/signup_info.dart';
import 'theme.dart';

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
            padding: AppTheme.pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Create your trAIn workout goals',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryText,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Identify your workout goals to best tailor your workout plan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCheckboxGroup(
                          title: 'What are your current fitness goals?',
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
                        // purple nav:
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<FormDataProvider>(context, listen: false)
                                  .updateGoals(selectedFitnessGoals);
                              Provider.of<FormDataProvider>(context, listen: false)
                                  .updateFrequency(selectedFrequency);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NewProfilePage3()),
                              );
                            },
                              child: const Text('Next'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Logo Image at the bottom
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
            fontSize: 18,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        ...options.map((option) {
          final isSelected = selectedOptions.contains(option);
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBackground : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: CheckboxListTile(
              value: isSelected,
              title: Text(
                option,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? Colors.white : AppTheme.secondaryText,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  value!
                      ? selectedOptions.add(option)
                      : selectedOptions.remove(option);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppTheme.primaryColor,
              checkColor: AppTheme.primaryText,
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 2,
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
