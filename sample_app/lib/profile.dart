import 'package:flutter/material.dart';
import 'theme.dart';
import 'user_data/signup_info.dart';
import 'package:provider/provider.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryBackground,
      appBar: AppBar(
        title: const Text('Profile', style: AppTheme.subTitleTextStyle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileHeader(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ProfileProgress(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TrainingGoals(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AthleteInfo(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TrainingInfo(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GoalInfo(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<FormDataProvider>(context, listen: false).formData;

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.only(
          top: 80.0,
          bottom: 12.0,
        ),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, 0),
            radius: 2,
            colors: [
              AppTheme.primaryColor, 
              AppTheme.secondaryColor, 
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF2D1945),
              width: 1,
            ),
          ),
        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Column: Profile Icon with padding
          Padding(
            padding: const EdgeInsets.only(left: 16.0), // Adjust the padding value as needed
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppTheme.secondaryBackground,
              child: Icon(Icons.person, size: 26, color: AppTheme.primaryText),
            ),
          ),
          const SizedBox(width: 16),

          // Right Column: Username and Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userData.username,
                  style: AppTheme.titleTextStyle.copyWith(fontSize: 26),
                ),
                // Text(
                //   'user@example.com',
                //   style: AppTheme.bodyTextStyle.copyWith(fontSize: 14),
                // ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class ProfileProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.secondaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.alternateColor),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_sharp,
                    color: AppTheme.primaryText,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '[0] Minutes Worked',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyTextStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.secondaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.alternateColor),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    color: AppTheme.primaryText,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '[0] Tasks Completed',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyTextStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrainingGoals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'editProfile');
      },
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 60,
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.alternateColor,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Training goals',
                  style: AppTheme.bodyTextStyle.copyWith(
                    color: AppTheme.primaryText, 
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.primaryText,
                    size: 25,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AthleteInfo extends StatelessWidget {
  const AthleteInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<FormDataProvider>(context, listen: false).formData;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.alternateColor, width: 1), 
        color: AppTheme.secondaryBackground,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.directions_run, color: AppTheme.primaryText),
            title: Text(
              'Athlete Info',
              style: AppTheme.titleTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.alternateColor,  
            thickness: 1,  
          ),
          
          const SizedBox(height: 12),  
          _buildDataRow('Height', "${formData.height} cm"),  // PULL FROM INSTANCE
          _buildDataRow('Weight', '${formData.weight} kg'), 
          _buildDataRow('Age', formData.age), 
          _buildDataRow('Gender', formData.gender), 
        ],
      ),
    );
  }

  // row creation helper
  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [

            Text(
              label,
              style: AppTheme.bodyTextStyle.copyWith(
                color: AppTheme.primaryText, 
                fontWeight: FontWeight.w500, 
              ),
            ),

            Text(
              value,
              style: AppTheme.bodyTextStyle.copyWith(
                color: AppTheme.secondaryText, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingInfo extends StatelessWidget {
  const TrainingInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<FormDataProvider>(context, listen: false).formData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.alternateColor, width: 1),  
        color: AppTheme.secondaryBackground,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.fitness_center, color: AppTheme.primaryText),
            title: Text(
              'Training Info',
              style: AppTheme.titleTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.alternateColor,  
            thickness: 1, 
          ),
          
          const SizedBox(height: 12), 
          
          _buildDataRow('Intensity Level', formData.intensity[0]),  // PULL INFO
          _buildDataRow('Goal Timeframe', formData.timeframe[0]),
          
          // Goal Description with constrained width
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Goal Description',
                style: AppTheme.bodyTextStyle,
              ),
              const SizedBox(width: 8),
              Expanded( // Fixed here, no space between Expanded and the opening parenthesis
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 220),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      formData.goals.map((goal) => goal).join(", "),
                      style: AppTheme.bodyTextStyle.copyWith(
                        color: AppTheme.secondaryText, 
                      ),
                      overflow: TextOverflow.visible, 
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )

        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [

            Text(
              label,
              style: AppTheme.bodyTextStyle.copyWith(
                color: AppTheme.primaryText, 
                fontWeight: FontWeight.w500, 
              ),
            ),

            Text(
              value,
              style: AppTheme.bodyTextStyle.copyWith(
                color: AppTheme.secondaryText, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class GoalInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<FormDataProvider>(context, listen: false).formData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.alternateColor, width: 1),
        color: AppTheme.secondaryBackground,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.rocket, color: AppTheme.primaryText),
            title: Text(
              'Goal Info',
              style: AppTheme.titleTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.alternateColor,
            thickness: 1,
          ),
          const SizedBox(height: 12),
          _buildDataRow('Goal Description', formData.workoutPlans),
        ],
      ),
    );
  }

  // Row creation helper
  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.bodyTextStyle.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                value,
                style: AppTheme.bodyTextStyle.copyWith(
                  color: AppTheme.secondaryText,
                ),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
