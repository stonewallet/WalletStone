import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Constants/colors.dart';
import '../controller/growth_controller.dart';
import 'day_toggle.dart';

class HideUnhideWidgets extends StatelessWidget {
  const HideUnhideWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GrowthController>(context);

    return Container(
      height: 45.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: textfieldColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DayToggleWidget(
            title: 'Crypto',
            color: stockGreenColor,
            isSelected: !provider.isSelectedItem(0),
            onTap: () {
              provider.toggleItem(0);
            },
          ),
          DayToggleWidget(
            title: 'Assets',
            color: blueAccentColor,
            isSelected: !provider.isSelectedItem(1),
            onTap: () {
              provider.toggleItem(1);
            },
          ),
          DayToggleWidget(
            title: 'Cash',
            color: redColor,
            isSelected: !provider.isSelectedItem(2),
            onTap: () {
              provider.toggleItem(2);
            },
          ),
          DayToggleWidget(
            title: 'Loans',
            color: amber,
            isSelected: !provider.isSelectedItem(3),
            onTap: () {
              provider.toggleItem(3);
            },
          ),
          DayToggleWidget(
            title: 'Trip',
            color: greyColor,
            isSelected: !provider.isSelectedItem(4),
            onTap: () {
              provider.toggleItem(4);
            },
          ),
        ],
      ),
    );
  }
}
