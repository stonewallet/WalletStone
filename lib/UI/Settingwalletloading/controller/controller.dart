import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/createWallet/createnewwallet.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/urls.dart';
import 'package:walletstone/UI/Create%20New%20Wallet/create_new_wallet_3.dart';
import 'package:walletstone/UI/settingWallet/createnewsettingwallet.dart';
import 'package:walletstone/UI/terms_page.dart';

class SettingWalletLoadingController extends GetxController {
  final _loading = true.obs;
  bool get loading => _loading.value;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    super.onInit();
    startTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void startTimer() async {
    await Future.delayed(const Duration(seconds: 5));

    _loading.value = false;

    try {
      walletResponse = await ApiServiceForCreateWallet().createWallet(
        name: settingwalletuserController.text,
        pass: settingwalletpassController.text,
      );
      if (kDebugMode) {
        print(walletResponse.mnemonicSeed);
      }

      if (walletResponse.mnemonicSeed.isNotEmpty) {
        Get.offAll(() => const CreateNewWalletPage3());
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Wallet Already Exit",
        '',
        backgroundColor: newGradient6,
        colorText: whiteColor,
        padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
        duration: const Duration(milliseconds: 4000),
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error creating wallet: $e');
      // Stop the controller or perform any other necessary actions here
    }
  }

  void increment() => count.value++;
  void checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? csrfToken = prefs.getString('csrfToken');
    final String? sessionId = prefs.getString('sessionId');

    if (csrfToken != null && sessionId != null) {
      Get.off(() => const TermsOfPage());
    } else {
      Get.off(() => const TermsOfPage());
    }
  }
}
