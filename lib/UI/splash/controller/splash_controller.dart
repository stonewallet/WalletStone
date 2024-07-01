import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import '../../Home/home_page.dart';
import '../../Security And Backup/security_and_backup.dart';
import '../../welcome_page.dart';

class SplashController extends GetxController {
  final _loading = true.obs;
  bool get loading => _loading.value;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    super.onInit();
    startTimer();
  }

  void startTimer() async {
    await Future.delayed(const Duration(seconds: 5));

    _loading.value = false;
    checkLoginStatus();
    // Navigate to the SignIn screen
    // Get.off(() => SigninView());
  }

  void increment() => count.value++;

  Future<void> loadBiometricState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    isBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    // });
  }

  Future<bool> authenticateWithBiometrics() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final bool isBiometricSupported =
        await localAuthentication.isDeviceSupported();
    final bool canCheckBiometric = await localAuthentication.canCheckBiometrics;

    bool isAuthentificated = false;
    if (isBiometricSupported && canCheckBiometric) {
      isAuthentificated = await localAuthentication.authenticate(
          localizedReason: 'please complete the biometrics to proceed');
    }
    return isAuthentificated;
  }

  void checkLoginStatus() async {
    await loadBiometricState();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? csrfToken = prefs.getString('csrfToken');
    final String? sessionId = prefs.getString('sessionId');

    if (csrfToken != null && sessionId != null) {
      if (isBiometricEnabled) {
        bool isBiometric = await authenticateWithBiometrics();
        if (isBiometric) {
          Get.off(() => const BottomNavigationPage());
        } else {
          Get.off(() => const WelcomePage());
        }
      } else {
        Get.off(() => const BottomNavigationPage());
      }
    } else {
      Get.off(() => const WelcomePage());
    }
  }
}
