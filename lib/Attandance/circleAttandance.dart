import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularAttendanceIndicator extends StatelessWidget {
  final double percentage; // Attendance percentage (e.g., 0.87 for 87%)

  const CircularAttendanceIndicator({
    Key? key,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 70.h,
          width: 70.h,
          child: CircularProgressIndicator(
            value: percentage, // e.g., 0.87 for 87%
            strokeWidth: 10,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            backgroundColor: Colors.grey[300],
          ),
        ),
        Text(
          '${(percentage * 100).toStringAsFixed(0)}%', // e.g., "87%"
          style: TextStyle(
            color: Colors.green,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
