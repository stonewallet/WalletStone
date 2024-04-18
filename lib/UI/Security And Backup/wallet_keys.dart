import 'package:flutter/material.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Model/keys/seed_key.dart';

import '../Constants/colors.dart';

class WalletKeysPage extends StatefulWidget {
  const WalletKeysPage({super.key, required this.dataKey});
  final Keys dataKey;

  @override
  State<WalletKeysPage> createState() => _WalletKeysPageState();
}

class _WalletKeysPageState extends State<WalletKeysPage> {
  bool button = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: appBarBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBackgroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
        ),
        title: Text("Wallet seed/keys",
            style: LargeTextStyle.large20700(whiteColor)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.03,
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: decorationColor),
                child: Text(
                  "DO NOT SHARE THESE WITH ANYONE ELSE INCLUDING SUPPORT.\n YOUR FUNDS CAN AND WILL BE STOLEN!",
                  style: RegularTextStyle.regular16600(redColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Spend key (public):",
                  style: RegularTextStyle.regular16600(iconColor)),
              const SizedBox(
                height: 10,
              ),
              Text(widget.dataKey.publicSpendKey!,
                  style: RegularTextStyle.regular16600(whiteColor)),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: width,
                height: 1,
                color: drawerColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Spend key (private):",
                style: RegularTextStyle.regular16600(iconColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.dataKey.secretSpendKey!,
                  style: RegularTextStyle.regular16600(whiteColor)),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: width,
                height: 1,
                color: drawerColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Text("View key (public):",
                  style: RegularTextStyle.regular16600(iconColor)),
              const SizedBox(
                height: 10,
              ),
              Text(widget.dataKey.publicViewKey!,
                  style: RegularTextStyle.regular16600(whiteColor)),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: width,
                height: 1,
                color: drawerColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Text("View key (private):",
                  style: RegularTextStyle.regular16600(iconColor)),
              const SizedBox(
                height: 10,
              ),
              Text(widget.dataKey.secretViewKey!,
                  style: RegularTextStyle.regular16600(whiteColor)),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: width,
                height: 1,
                color: drawerColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Wallet seed:",
                  style: RegularTextStyle.regular16600(iconColor)),
              const SizedBox(
                height: 10,
              ),
              Text(widget.dataKey.mnemonicSeed!,
                  style: RegularTextStyle.regular16600(iconColor)),
              const SizedBox(
                height: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
