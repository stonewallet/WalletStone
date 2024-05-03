import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/restore/restore_wallet.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Wallet/restore_wallet_loading/controller/restore_load_controller.dart';
import 'package:walletstone/UI/Wallet/restore_wallet_loading/loading_view/restore_loading.dart';

import '../Constants/colors.dart';

TextEditingController walletNameController = TextEditingController();
TextEditingController seedPhraseController = TextEditingController();
TextEditingController passwordControllerForSeed = TextEditingController();

class RestoreFromSeedPage extends StatefulWidget {
  const RestoreFromSeedPage({super.key});

  @override
  State<RestoreFromSeedPage> createState() => _RestoreFromSeedPageState();
}

class _RestoreFromSeedPageState extends State<RestoreFromSeedPage> {
  @override
  void initState() {
    super.initState();
    walletNameController.clear();
    seedPhraseController.clear();
    passwordControllerForSeed.clear();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

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
        title: Text("Restore from seed",
            style: LargeTextStyle.large20500(whiteColor)),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 17,
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 45,
                  width: width * 0.95,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: TextField(
                    autofocus: true,
                    cursorColor: cursorColor,
                    controller: walletNameController,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: RegularTextStyle.regular16bold(whiteColor),
                    decoration: InputDecoration(
                      hintText: "New Wallet name",
                      hintStyle: RegularTextStyle.regular16bold(cursorColor),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  // height: 45,
                  width: width * 0.95,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: TextField(
                    autofocus: true,
                    cursorColor: cursorColor,
                    controller: seedPhraseController,
                    textAlign: TextAlign.start,
                    minLines: 1,
                    maxLines: 5,
                    textAlignVertical: TextAlignVertical.center,
                    style: RegularTextStyle.regular16bold(whiteColor),
                    decoration: InputDecoration(
                      hintText: "Enter your seed phrase",
                      hintStyle: RegularTextStyle.regular16bold(cursorColor),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 45,
                  width: width * 0.95,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: TextField(
                    autofocus: true,
                    cursorColor: cursorColor,
                    controller: passwordControllerForSeed,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: RegularTextStyle.regular16bold(whiteColor),
                    decoration: InputDecoration(
                      hintText: " New Wallet Password",
                      hintStyle: RegularTextStyle.regular16bold(cursorColor),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Consumer<ApiRestorePassWord>(
                builder: (context, value, child) => Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                          onPressed: () async {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context)
                            //   =>  const CreateNewWalletPage()),
                            // );
                            // var response = await value.changeRestorePassword(
                            //     name: walletNameController.text,
                            //     seed: seedPhraseController.text,
                            //     password: passwordControllerForSeed.text);
                            // if (response.message != null) {
                            //   Get.back();
                            //   Get.snackbar(
                            //     "Password Changed successfully",
                            //     '',
                            //     backgroundColor: newGradient6,
                            //     colorText: whiteColor,
                            //     padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                            //     duration: const Duration(milliseconds: 4000),
                            //     snackPosition: SnackPosition.BOTTOM,
                            //   );
                            // } else {
                            //   Get.snackbar(
                            //     "Something Went Wrong",
                            //     '',
                            //     backgroundColor: newGradient6,
                            //     colorText: whiteColor,
                            //     padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                            //     duration: const Duration(milliseconds: 4000),
                            //     snackPosition: SnackPosition.BOTTOM,
                            //   );
                            // }
                            Get.off(() => RestoreWalletLoadingView());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor2,
                              surfaceTintColor: Colors.black,
                              shadowColor: whiteColor,
                              elevation: 4),
                          child: Text("Restore",
                              style: LargeTextStyle.large20700(whiteColor))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
