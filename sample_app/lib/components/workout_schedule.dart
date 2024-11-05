import 'sample_workout.dart';
import 'package:train_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getDate() {
  final DateTime now = DateTime.now();
  
  // Calculate the difference to Monday (1) based on the current weekday
  final int daysToSubtract = now.weekday - DateTime.monday;
  final DateTime monday = now.subtract(Duration(days: daysToSubtract));
  
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  return formatter.format(monday);
}

class WorkoutscheduleWidget extends StatefulWidget {
  const WorkoutscheduleWidget({super.key});

  @override
  State<WorkoutscheduleWidget> createState() => _WorkoutscheduleWidgetState();
}

class _WorkoutscheduleWidgetState extends State<WorkoutscheduleWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(
                0,
                2,
              ),
              spreadRadius: 0,
            )
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Training - ${getDate()}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              ListView(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Builder(
                    builder: (context) => Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                elevation: 0,
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                alignment: AlignmentDirectional(0, 0)
                                    .resolve(Directionality.of(context)),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * .75,
                                  child: SampleWorkoutWidget(),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.firstBackground,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                          'Monday',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                          selectionColor: AppTheme.primaryColor,
                                        ),
                                    Text(
                                          'Chest and Triceps',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                        ),
                                  ],
                                ),
                                Icon(
                                  Icons.fitness_center,
                                  size: 24,
                                  color: AppTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.secondBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                      'Tuesday',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                                Text(
                                      'Back and Biceps',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                              ],
                            ),
                            Icon(
                              Icons.fitness_center,
                              size: 24,
                              color: AppTheme.secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.firstBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                      'Wednesday',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                                Text(
                                      'Legs and Shoulders',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                              ],
                            ),
                            Icon(
                              Icons.fitness_center,
                              size: 24,
                              color: AppTheme.tertiaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.secondBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                      'Thursday',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                                Text(
                                      'Rest Day',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                              ],
                            ),
                            Icon(
                              Icons.bed,
                              size: 24,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.firstBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                      'Friday',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                                Text(
                                      'Full Body',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                              ],
                            ),
                            Icon(
                              Icons.fitness_center,
                              size: 24,
                              color: AppTheme.secondaryColor
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.secondBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                      'Saturday',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                                Text(
                                      'Cardio and Abs',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                              ],
                            ),
                            Icon(
                              Icons.directions_run,
                              size: 24,
                              color: AppTheme.tertiaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.firstBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                      'Sunday',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                                Text(
                                      'Rest Day',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.alternateColor),
                                    ),
                              ],
                            ),
                            Icon(
                              Icons.bed,
                              size: 24,
                              color: AppTheme.primaryColor,
                            ),
                          ],
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
    );
  }
}
