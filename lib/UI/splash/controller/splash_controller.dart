import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import '../../Home/home_page.dart';
import '../../Security And Backup/security_and_backup.dart';
import '../../welcome_page.dart';

class SplashController extends GetxController {
  final _loading = true.obs;
  bool get loading => _loading.value;
  final count = 0.obs;
  bool permissionGranted = false;

  @override
  void onInit() {
    super.onInit();
    super.onInit();
    getStoragePermission();
    startTimer();
  }

  void startTimer() async {
    await Future.delayed(const Duration(seconds: 4));

    _loading.value = false;
    checkLoginStatus();
    // Navigate to the SignIn screen
    // Get.off(() => SigninView());
  }

  void increment() => count.value++;

  Future<void> loadBiometricState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;
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

  Future<void> getStoragePermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin plugin = DeviceInfoPlugin();
      AndroidDeviceInfo? android = await plugin.androidInfo;
      if (android.version.sdkInt < 33) {
        if (await Permission.storage.request().isGranted &&
            await Permission.manageExternalStorage.request().isGranted) {
          // setState(() {
          permissionGranted = true;
          // });
        } else if (await Permission.storage.request().isPermanentlyDenied) {
          await getStoragePermission();
        } else if (await Permission.audio.request().isDenied) {
          // setState(() {
          permissionGranted = false;
          // });
        }
      } else {
        if (await Permission.photos.request().isGranted &&
            await Permission.videos.request().isGranted &&
            await Permission.audio.request().isGranted) {
          // setState(() {
          permissionGranted = true;
          // });
        } else if (await Permission.photos.request().isPermanentlyDenied) {
          await getStoragePermission();
        } else if (await Permission.photos.request().isDenied &&
            await Permission.microphone.request().isDenied &&
            await Permission.mediaLibrary.request().isDenied &&
            await Permission.storage.request().isDenied) {
          // setState(() {
          permissionGranted = false;
          // });
        }
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted &&
          await Permission.microphone.request().isGranted &&
          await Permission.mediaLibrary.request().isGranted &&
          await Permission.storage.request().isGranted) {
        // setState(() {
        permissionGranted = true;
        // });
      } else if (await Permission.photos.request().isPermanentlyDenied &&
          await Permission.microphone.request().isDenied &&
          await Permission.mediaLibrary.request().isDenied &&
          await Permission.storage.request().isDenied) {
        await getStoragePermission();
      } else if (await Permission.photos.request().isDenied &&
          await Permission.microphone.request().isDenied &&
          await Permission.mediaLibrary.request().isDenied &&
          await Permission.storage.request().isDenied) {
        // setState(
        //   () {
        getStoragePermission();
        // },
        // );
      }
    }
  }
}
