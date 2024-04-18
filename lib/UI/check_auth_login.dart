import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/Auth/auth_check.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/T2FAuth/two_f_login.dart';
import 'package:walletstone/UI/login_page.dart';

class CheckAuthLogin extends StatefulWidget {
  const CheckAuthLogin({super.key});

  @override
  State<CheckAuthLogin> createState() => _CheckAuthLoginState();
}

class _CheckAuthLoginState extends State<CheckAuthLogin> {
  TextEditingController loginAuthController = TextEditingController();
  TextEditingController currencyController = TextEditingController();

  @override
  void initState() {
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
        title: Text("Login", style: LargeTextStyle.large20700(whiteColor)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.02,
          ),
          Text(
            "Check Login",
            style: NasalTextStyle.nasal(whiteColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "User name",
                style: RegularTextStyle.regular16600(whiteColor),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 45,
                padding:
                    EdgeInsets.only(left: width * 0.15, right: width * 0.15),
                alignment: Alignment.center,
                child: TextField(
                  // autofocus: true,
                  cursorColor: Colors.blue,
                  controller: loginAuthController,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  style: RegularTextStyle.regular16600(whiteColor),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: borderColor, width: 1.0),
                    ),
                    fillColor: fillColor,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: borderColor, width: 1.0),
                    ),
                    contentPadding: EdgeInsets.only(left: 20),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),
          // Container(
          //   height: 45,
          //   width: width * 0.95,
          //   padding: const EdgeInsets.only(left:15, right: 15),
          //   alignment: Alignment.center,
          //   child: TextField(
          //     autofocus: true,
          //     cursorColor: cursorColor,
          //     controller: currencyController,
          //     textAlign: TextAlign.start,
          //     textAlignVertical: TextAlignVertical.center,
          //     style: RegularTextStyle.regular16bold(whiteColor),
          //     decoration:  InputDecoration(
          //       hintText: "Currency",
          //       hintStyle:  RegularTextStyle.regular16bold(cursorColor) ,
          //       enabledBorder: const UnderlineInputBorder(
          //         borderSide: BorderSide(color: cursorColor),
          //       ),
          //       focusedBorder: const UnderlineInputBorder(
          //         borderSide: BorderSide(color: cursorColor),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.4,
              child: Consumer<ApiCheckAuth>(
                builder: (context, value, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    onPressed: () async {
                      var response = await value.check2FAuth(
                        name: loginAuthController.text,
                      );
                      if (response.message!) {
                        print(response.message);
                        Get.offAll(() => const TWOFactorLogin());
                      } else {
                        Get.offAll(() => const LoginPage());
                        print("it is false ${response.message}");
                      }
                    },
                    child: Text(
                      "Next",
                      style: RegularTextStyle.regular18600(whiteColor),
                    )),
              ),
            ),

            // SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
