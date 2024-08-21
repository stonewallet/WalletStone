import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/UI/growth_chart_screen/controller/growth_controller.dart';
import '../Constants/colors.dart';
import '../Constants/text_styles.dart';
import 'widget/chart.dart';
import 'widget/custom_dropwdown.dart';
import 'widget/customise_widgets.dart';
import 'widget/hide_unhide_widget.dart';
import 'widget/items_builder.dart';

class GrowthChartScreen extends StatefulWidget {
  const GrowthChartScreen({super.key});

  @override
  State<GrowthChartScreen> createState() => _GrowthChartScreenState();
}

class _GrowthChartScreenState extends State<GrowthChartScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<GrowthController>(context, listen: false);
    provider.fetchDataForLineChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
        ),
        title: Text(
          "Growth",
          style: LargeTextStyle.large20700(whiteColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 20.w,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [newGradient5, newGradient6],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Growth (\$)',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.w),
                  const CustomiseDaysWidget(),
                  SizedBox(
                    height: 40.w,
                  ),
                  const CustomChart(),
                  SizedBox(height: 30.w),
                  const HideUnhideWidgets(),
                  SizedBox(height: 15.w),
                  const CustomPortfolioDropdown(),
                  const ItemsViewBuilder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
