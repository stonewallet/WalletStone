import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../Constants/text_styles.dart';

class GrowthChartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GrowthChartAppBar({
    super.key,
  });
  @override
  final Size preferredSize = const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
