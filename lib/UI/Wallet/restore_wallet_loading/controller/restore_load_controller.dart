import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/restore/restore_wallet.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Wallet/restore_from_seed.dart';
import 'package:walletstone/UI/terms_page.dart';

class RestoreWalletController extends GetxController {
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
    await Future.delayed(const Duration(seconds: 10));

    _loading.value = false;

    try {
      var response = await ApiRestorePassWord().changeRestorePassword(
          name: walletNameController.text,
          seed: seedPhraseController.text,
          password: passwordControllerForSeed.text);

      if (kDebugMode) {
        print(response.message);
      }

      if (response.message!.isNotEmpty) {
        Get.close(3);
        Get.snackbar(
          response.message!,
          '',
          backgroundColor: newGradient6,
          colorText: whiteColor,
          padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
          duration: const Duration(milliseconds: 4000),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Restore Can't Complete",
        '',
        backgroundColor: newGradient6,
        colorText: whiteColor,
        padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
        duration: const Duration(milliseconds: 4000),
        snackPosition: SnackPosition.BOTTOM,
      );
      if (kDebugMode) {
        print('Error creating wallet: $e');
      }
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
