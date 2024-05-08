import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/Auth/auth_check.dart';
import 'package:walletstone/API/Auth/auth_create.dart';
import 'package:walletstone/API/Auth/auth_otp_login.dart';
import 'package:walletstone/API/change_password/change_user_password.dart';
import 'package:walletstone/API/contact/post_contact.dart';
import 'package:walletstone/API/createNotification/createnotification.dart';
import 'package:walletstone/API/forget_password/forget_password.dart';
import 'package:walletstone/API/logout/logout.dart';
import 'package:walletstone/API/receive_address/receive_address.dart';
import 'package:walletstone/API/restore/restore_wallet.dart';
import 'package:walletstone/API/seed/key/get_seed_key.dart';
import 'package:walletstone/API/send_wallet/send_wallet.dart';
import 'package:walletstone/API/wallet_balance/wallet_balance.dart';
import 'package:walletstone/UI/Home/provider/notification_provider.dart';
import 'package:walletstone/UI/Security%20And%20Backup/provider/twofactor_sw.dart';
import 'package:walletstone/UI/Security%20And%20Backup/security_and_backup.dart';
import 'package:walletstone/UI/Trips/provider/new_trip_provider.dart';
import 'package:walletstone/UI/Trips/provider/trip_provider.dart';
import 'package:walletstone/UI/portfolio/controller/asset_provider.dart';
import 'package:walletstone/UI/splash/splash_view.dart/splash_view.dart';
import 'package:walletstone/UI/welcome_page.dart';
import 'package:walletstone/controller/local/local_database.dart';
import 'package:walletstone/widgets/session_listener.dart';
import 'UI/Constants/colors.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Set up HttpOverrides before making HTTP requests
void setupHttpOverrides() {
  HttpOverrides.global = MyHttpOverrides();
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  // Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase.createDatabase();
  runApp(const MyApp());

  // disableCapture();
}

// disableCapture() async {
//   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navKey = GlobalKey<NavigatorState>();

  Future<void> _loadSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOption = prefs.getString('selectedOption') ?? '10 minutes';
    setState(() {
      selectedOption = savedOption;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
  }

  @override
  Widget build(BuildContext context) {
    int durationInMinutes = int.parse(selectedOption.split(' ')[0]);
    return SessionTimeOutListener(
      duration: Duration(minutes: durationInMinutes),
      onTimeOut: () async {
        if (kDebugMode) {
          print("Time Out");
        }
        final SharedPreferences sharedPref =
            await SharedPreferences.getInstance();
        sharedPref.remove('name');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('selectedOption');
        var response = await ApiServiceForLogOut().logOut();

        if (response.message != null) {
          Navigator.of(_navKey.currentState!.context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const WelcomePage(),
              ),
              (route) => false);
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.remove('csrfToken');
          sharedPreferences.remove('sessionId');
          // Get.snackbar(
          //   "Logout successfully",
          //   '',
          //   backgroundColor: newGradient6,
          //   colorText: whiteColor,
          //   padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
          //   duration: const Duration(milliseconds: 4000),
          //   snackPosition: SnackPosition.BOTTOM,
          // );
          // var snackBar = SnackBar(
          //     content: Text(
          //         "Assets created successfully"));
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(snackBar);
        } else {
          // Get.snackbar(
          //   "Something gone wrong",
          //   '',
          //   backgroundColor: newGradient6,
          //   colorText: whiteColor,
          //   padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
          //   duration: const Duration(milliseconds: 4000),
          //   snackPosition: SnackPosition.BOTTOM,
          // );
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => NewTripProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiServiceForCreateNotification(),
          ),
          ChangeNotifierProvider(
            create: (context) => NotificationProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => TripProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiServiceForSEEDKey(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiServiceForContact(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiChangePassword(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiCheckAuth(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiCreateAuth(),
          ),
          ChangeNotifierProvider(
            create: (context) => TwoFactorProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => APiAuthOTPLogin(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiForSendWallet(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiRestorePassWord(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiWalletBalance(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiPublicAddress(),
          ),
          ChangeNotifierProvider(
            create: (context) => ApiForgetPassword(),
          ),
          ChangeNotifierProvider(
            create: (context) => AssetProvider(),
          ),
        ],
        child: GetMaterialApp(
          navigatorKey: _navKey,
          debugShowCheckedModeBanner: false,
          title: 'Stone Wallet',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: purpleColor),
            useMaterial3: true,
          ),
          home: SplashView(),
        ),
      ),
    );
  }
}
