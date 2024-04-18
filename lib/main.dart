import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/Auth/auth_check.dart';
import 'package:walletstone/API/Auth/auth_create.dart';
import 'package:walletstone/API/Auth/auth_otp_login.dart';
import 'package:walletstone/API/change_password/change_user_password.dart';
import 'package:walletstone/API/contact/post_contact.dart';
import 'package:walletstone/API/createNotification/createnotification.dart';
import 'package:walletstone/API/seed/key/get_seed_key.dart';
import 'package:walletstone/API/send_wallet/send_wallet.dart';
import 'package:walletstone/UI/Home/provider/notification_provider.dart';
import 'package:walletstone/UI/Security%20And%20Backup/provider/twofactor_sw.dart';
import 'package:walletstone/UI/Trips/provider/new_trip_provider.dart';
import 'package:walletstone/UI/Trips/provider/trip_provider.dart';
import 'package:walletstone/UI/splash/splash_view.dart/splash_view.dart';
import 'package:walletstone/controller/local/local_database.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

//  Future<void> loadBiometricState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prevent = prefs.getBool('prevent') ?? false;
//     });
//   }

//   disableCapture() async {
//     if (prevent) {
//       await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//     } else {
//       await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stone Wallet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: purpleColor),
          useMaterial3: true,
        ),
        home: SplashView(),
      ),
    );
  }
}
