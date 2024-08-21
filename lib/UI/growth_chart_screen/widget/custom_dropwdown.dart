import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/UI/growth_chart_screen/controller/growth_controller.dart';

import '../../Constants/colors.dart';

class CustomPortfolioDropdown extends StatefulWidget {
  const CustomPortfolioDropdown({super.key});

  @override
  CustomPortfolioDropdownState createState() => CustomPortfolioDropdownState();
}

class CustomPortfolioDropdownState extends State<CustomPortfolioDropdown> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GrowthController>(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: drawerColor2,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: provider.selectedDropdownValue,
          hint: const Text(
            'Select a portfolio item',
            style: TextStyle(color: whiteColor),
          ),
          dropdownColor: textfieldColor,
          icon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: whiteColor,
          ),
          items: const [
            DropdownMenuItem(
              value: 'Crypto',
              child: Text(
                'Crypto',
                style: TextStyle(color: whiteColor),
              ),
            ),
            DropdownMenuItem(
              value: 'Assets',
              child: Text(
                'Assets',
                style: TextStyle(color: whiteColor),
              ),
            ),
            DropdownMenuItem(
              value: 'Cash',
              child: Text(
                'Cash',
                style: TextStyle(color: whiteColor),
              ),
            ),
            DropdownMenuItem(
              value: 'Loans',
              child: Text(
                'Loans',
                style: TextStyle(color: whiteColor),
              ),
            ),
            DropdownMenuItem(
              value: 'Trips',
              child: Text(
                'Trips',
                style: TextStyle(color: whiteColor),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              provider.selectedDropdownValue = value;
              provider.toggelItemsBuilder();
            });
          },
        ),
      ),
    );
  }
}
