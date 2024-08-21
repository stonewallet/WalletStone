import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/colors.dart';

class DayToggleWidget extends StatelessWidget {
  const DayToggleWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.color = blueDark,
  });

  final String title;
  final bool isSelected;
  final Color color;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        height: 40.w,
        // width: 45.w,
        decoration: BoxDecoration(
          color: isSelected ? color : transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: whiteColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
