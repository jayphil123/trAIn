import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data/signup_info.dart';
import 'signup_load.dart';
import 'theme.dart';

class NewProfilePage3 extends StatefulWidget {
  const NewProfilePage3({super.key});

  @override
  State<NewProfilePage3> createState() => _NewProfilePage3State();
}

class _NewProfilePage3State extends State<NewProfilePage3> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> selectedIntensityLevels = [];
  final List<String> selectedTimeframes = [];
  final TextEditingController goalDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    goalDescriptionController.dispose();
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
            padding: AppTheme.pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                        const SizedBox(height: 8),
                        Text(
                          'Identify your workout goals to best tailor your workout plan',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCheckboxGroup(
                          title: 'What intensity level do you prefer?',
                          options: [
                            'Light\n (walking, gentle stretching)',
                            'Moderate\n (jogging, bodyweight exercises)',
                            'Intense\n (HIIT, heavy lifting)',
                          ],
                          selectedOptions: selectedIntensityLevels,
                        ),
                        const SizedBox(height: 20),
                        _buildCheckboxGroup(
                          title: 'What timeframe are you aiming for?',
                          options: [
                            '1-3 months',
                            '3-6 months',
                            '6-12 months',
                            'No specific timeframe',
                          ],
                          selectedOptions: selectedTimeframes,
                        ),
                        const SizedBox(height: 20),
                        _buildGoalDescriptionField(),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<FormDataProvider>(context, listen: false)
                                  .updateWorkoutPlans(goalDescriptionController.text);
                              Provider.of<FormDataProvider>(context, listen: false)
                                  .updateIntensity(selectedIntensityLevels);
                              Provider.of<FormDataProvider>(context, listen: false)
                                  .updateTimeframe(selectedTimeframes);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SplashScreen(fromLogin: false,)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Finish',
                            ),
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
            fontSize: 18,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
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

  // helper
  Widget _buildGoalDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us about your fitness goals',
          style: const TextStyle(
            fontSize: 18,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: goalDescriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Describe your fitness goals in a few sentences...',
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
