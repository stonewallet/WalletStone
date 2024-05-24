import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/Auth/auth_create.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Security%20And%20Backup/provider/twofactor_sw.dart';
import 'package:walletstone/UI/welcome_page.dart';
import 'package:walletstone/widgets/global.dart';

import '../Constants/colors.dart';

class Setup2FANext extends StatefulWidget {
  const Setup2FANext({super.key});

  @override
  State<Setup2FANext> createState() => _Setup2FANextState();
}

class _Setup2FANextState extends State<Setup2FANext> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final twoFactorProvider = Provider.of<TwoFactorProvider>(context);

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
        title: Text("Setup 2FA", style: LargeTextStyle.large20700(whiteColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Allow For Two Factor',
                        style: LargeTextStyle.large20500(whiteColor),
                      ),
                      Consumer<ApiCreateAuth>(
                          builder: (context, provider, child) {
                        // var authStatus = provider.checkAuthStatus();
                        if (kDebugMode) {
                          print(" data is ${twoFactorProvider.isEnabled}");
                        }
                        // print(authStatus);
                        return Switch.adaptive(
                          inactiveThumbColor: redColor,
                          activeColor: twoFactorProvider.isEnabled
                              ? stockGreenColor
                              : redColor,
                          value: twoFactorProvider.isEnabled,
                          onChanged: (value) async {
                            twoFactorProvider.toggleSwitch(value);
                            if (value) {
                              var response = await provider.authEnablePost();
                              alert(response.message!);
                              if (kDebugMode) {
                                print("value is enabled that is := $value");
                              }
                            } else {
                              var response = await provider.authDisablePost();
                              alert(response.message!);
                              if (kDebugMode) {
                                print("not true it's  $value");
                              }
                            }
                          },
                        );
                      }),
                    ],
                  ),
                  Text("Scan the QR code on another device",
                      style: RegularTextStyle.regular15600(iconColor)),
                  const SizedBox(
                    height: 15,
                  ),
                  const QRCodeImageWidget(),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Consumer<ApiCreateAuth>(
            builder: (context, value, child) => SizedBox(
              width: width * 0.4,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor,
                  surfaceTintColor: blackColor,
                  shadowColor: whiteColor,
                  elevation: 2,
                ),
                onPressed: () async {
                  await value.authDisablePost();
                  var response = await value.deleteAuthDevice();

                  if (response.message != null) {
                    Get.offAll(() => const WelcomePage());
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.remove('csrfToken');
                    sharedPreferences.remove('sessionId');
                    alert(response.message!);
                  } else {
                    var snackBar =
                        const SnackBar(content: Text("Something gone wrong"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    // if (response.message != null) {

                    //   // var snackBar = SnackBar(
                    //   //     content: Text(
                    //   //         "Assets created successfully"));
                    //   // ScaffoldMessenger.of(context)
                    //   //     .showSnackBar(snackBar);
                    // } else {
                  }
                },
                child: Text(
                  "Delete",
                  style: LargeTextStyle.large18800(whiteColor),
                ),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor2,
                  surfaceTintColor: blackColor,
                  shadowColor: whiteColor,
                  elevation: 4),
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Done",
                style: LargeTextStyle.large18800(whiteColor),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class QRCodeImageWidget extends StatefulWidget {
  const QRCodeImageWidget({super.key});

  @override
  State<QRCodeImageWidget> createState() => _QRCodeImageWidgetState();
}

class _QRCodeImageWidgetState extends State<QRCodeImageWidget> {
  final apiCreateAuthProvider = ApiCreateAuth();
  Uint8List? _qrCodeData;

  @override
  void initState() {
    super.initState();
    _loadQRCodeData();
  }

  Future<void> _loadQRCodeData() async {
    final qrCodeData = await apiCreateAuthProvider.create2FAuth();
    setState(() {
      _qrCodeData = qrCodeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_qrCodeData == null) {
      return const CircularProgressIndicator();
    } else {
      return Image.memory(_qrCodeData!);
    }
  }
}

class ImageFromAPI extends StatelessWidget {
  final String imageData;

  const ImageFromAPI({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decodedImage = base64Decode(imageData);
    return Image.memory(decodedImage);
  }
}
