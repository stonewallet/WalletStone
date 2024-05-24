import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/Auth/auth_check.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/T2FAuth/two_f_login.dart';
import 'package:walletstone/UI/login_page.dart';
import 'package:walletstone/widgets/global.dart';

class CheckAuthLogin extends StatefulWidget {
  const CheckAuthLogin({super.key});

  @override
  State<CheckAuthLogin> createState() => _CheckAuthLoginState();
}

class _CheckAuthLoginState extends State<CheckAuthLogin> {
  TextEditingController loginAuthController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    cursorColor: Colors.blue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: loginAuthController,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: RegularTextStyle.regular16600(whiteColor),
                    decoration: InputDecoration(
                      fillColor: fillColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: blueAccentColor,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: blueAccentColor,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: borderColor,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorStyle: const TextStyle(height: 0.1),
                      errorMaxLines: 2,
                      contentPadding:
                          const EdgeInsets.only(left: 10, bottom: 10),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Your Username';
                      }
                      return null;
                    },
                  ),
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
                      if (_formKey.currentState!.validate()) {
                        // var userResponse = await usergetProvider.getAllUser();
                        // if (userResponse.username == loginAuthController.text) {
                        var response = await value.check2FAuth(
                          name: loginAuthController.text,
                        );
                        if (loginAuthController.text.isNotEmpty) {
                          if (response == true) {
                            if (kDebugMode) {
                              print(response);
                            }
                            Get.offAll(() => const TWOFactorLogin());
                            print("it is true ${response}");
                          } else if (response == false) {
                            Get.offAll(() => const LoginPage());

                            print("it is false ${response}");
                          } else {
                            alert(response);
                          }
                        }
                        // }
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
