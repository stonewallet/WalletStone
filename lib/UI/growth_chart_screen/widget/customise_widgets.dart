import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Constants/colors.dart';
import '../controller/growth_controller.dart';
import 'customise_popup.dart';
import 'day_toggle.dart';

class CustomiseDaysWidget extends StatelessWidget {
  const CustomiseDaysWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GrowthController>(context);
    return Container(
      height: 45.w,
      width: 234.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: textfieldColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          DayToggleWidget(
            title: '7D',
            isSelected: provider.isSelectedDay == 0,
            onTap: () {
              provider.selectDays(0);
            },
          ),
          DayToggleWidget(
            title: '30D',
            isSelected: provider.isSelectedDay == 1,
            onTap: () {
              provider.selectDays(1);
            },
          ),
          DayToggleWidget(
            title: '90D',
            isSelected: provider.isSelectedDay == 2,
            onTap: () {
              provider.selectDays(2);
            },
          ),
          DayToggleWidget(
            title: 'Customise',
            isSelected: provider.isSelectedDay == 3,
            onTap: () {
              provider.daysController.text = provider.durationDay.toString();
              provider.selectDays(3);

              customisePopUp(context, provider);
            },
          ),
        ],
      ),
    );
  }
}
