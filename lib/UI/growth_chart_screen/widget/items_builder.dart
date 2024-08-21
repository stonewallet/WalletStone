import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/colors.dart';
import '../controller/growth_controller.dart';

class ItemsViewBuilder extends StatelessWidget {
  const ItemsViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GrowthController>(
      builder: (context, provider, child) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.itemsViewList.length,
        itemBuilder: (context, index) => ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  provider.itemsViewList[index].name,
                  style: const TextStyle(color: whiteColor),
                ),
              ),
              Expanded(
                child: Text(
                  provider.formatDate(provider.itemsViewList[index].date),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: whiteColor),
                ),
              ),
              Expanded(
                child: Text(
                  "\$ ${provider.formatToThreeDecimals(provider.itemsViewList[index].amount)}",
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: whiteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
