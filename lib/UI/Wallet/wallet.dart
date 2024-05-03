import 'package:flutter/material.dart';
import 'package:walletstone/API/settingwallet/get_setting_wallet.dart';
import 'package:walletstone/UI/Model/setting/setting_wallet.dart';
import 'package:walletstone/UI/Wallet/restore_wallet.dart';
import 'package:walletstone/UI/settingWallet/createnewsettingwallet.dart';

import '../Constants/colors.dart';
import '../Constants/text_styles.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late ApiServiceForGetSettingWallets apiServiceForGetSettingWallets;

  @override
  void initState() {
    apiServiceForGetSettingWallets = ApiServiceForGetSettingWallets();
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
        title: Text("Wallet", style: LargeTextStyle.large20700(whiteColor)),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    // const Icon(
                    //   Icons.edit,
                    //   size: 20,
                    //   color: whiteColor,
                    // )
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

                      return ListView.builder(
                        key: UniqueKey(),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                // Row(
                                //   children: [
                                //     Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.end,
                                //       children: [
                                //         IconButton(
                                //           onPressed: () {},
                                //           icon: const Icon(
                                //             Icons.edit,
                                //             size: 20,
                                //             color: whiteColor,
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //     SizedBox(
                                //       width: width * 0.05,
                                //     )
                                //   ],
                                // )
                              ],
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
          // Expanded(
          //   flex: 4,
          //   child:
          // ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 50,
            width: width * 0.8,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingCreateNewWallet()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor2,
                    surfaceTintColor: blackColor,
                    shadowColor: whiteColor,
                    elevation: 4),
                child: Text("+  Create New Wallet",
                    style: LargeTextStyle.large20700(whiteColor))),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor3,
                    surfaceTintColor: blackColor,
                    shadowColor: whiteColor,
                    elevation: 4),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RestoreWalletPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.restart_alt,
                      size: 20,
                      color: whiteColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text("Restore Wallet",
                        style: LargeTextStyle.large20700(whiteColor)),
                  ],
                )),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
