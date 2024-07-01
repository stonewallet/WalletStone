import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walletstone/API/seed/key/get_seed_key.dart';
import 'package:walletstone/API/settingwallet/get_setting_wallet.dart';
import 'package:walletstone/UI/Model/setting/setting_wallet.dart';
import 'package:walletstone/UI/Security%20And%20Backup/wallet_keys.dart';
import '../Constants/colors.dart';
import '../Constants/text_styles.dart';

class SelectWalletPage extends StatefulWidget {
  const SelectWalletPage({super.key});

  @override
  State<SelectWalletPage> createState() => _SelectWalletPageState();
}

class _SelectWalletPageState extends State<SelectWalletPage> {
  late ApiServiceForGetSettingWallets apiServiceForGetSettingWallets;
  late ApiServiceForSEEDKey apiServiceForSEEDKey;
  @override
  void initState() {
    apiServiceForGetSettingWallets = ApiServiceForGetSettingWallets();
    apiServiceForSEEDKey = ApiServiceForSEEDKey();
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
        elevation: 0,
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
        title:
            Text("Select Wallet", style: LargeTextStyle.large20700(whiteColor)),
      ),
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Wallets",
                          style: LargeTextStyle.large18800(whiteColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 0.5,
                indent: 10,
                endIndent: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: FutureBuilder<List<GetWallet>>(
                  future:
                      apiServiceForGetSettingWallets.getDataForSettingWallet(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No data",
                          style: LargeTextStyle.large18800(whiteColor),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          "No data",
                          style: LargeTextStyle.large18800(whiteColor),
                        ),
                      );
                    } else {
                      final List<GetWallet> wallets = snapshot.data!;
                      // final dataList = Provider.of<ApiServiceForSEEDKey>(context, listen: false);
                      return ListView.builder(
                        key: UniqueKey(),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              log(wallets[index].mnemonic.toString());
                              var response = await apiServiceForSEEDKey
                                  .seedkey(wallets[index].mnemonic!);

                              if (response.publicSpendKey!.isNotEmpty) {
                                final value = response;
                                Get.to(() => WalletKeysPage(
                                      dataKey: value,
                                    ));
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: width * 0.05,
                                      ),
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Image.asset(
                                          'assets/Icons/wallet-filled-money-tool.png',
                                          color: newGradient1,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(wallets[index].mnemonic!,
                                          style: LargeTextStyle.large18800(
                                              whiteColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: wallets.length,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
