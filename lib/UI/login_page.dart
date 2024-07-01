import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/api_provider.dart';
import 'package:walletstone/Responses/travel_post_response.dart';
import 'package:walletstone/UI/Constants/strings.dart';
import 'package:walletstone/UI/Create%20New%20Wallet/create_new_wallet_2.dart';
import 'package:walletstone/UI/Home/home_page.dart';
import 'package:walletstone/widgets/forget_password.dart';

import 'Constants/colors.dart';
import 'Constants/text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    loadName();
    passwordVisible = true;
  }

  loadName() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    userNameController.text = sharedPref.getString('name')!;
  }

  bool isLoading = false;
  bool passwordVisible = false;

  TravelPostResponse travelPostResponse = TravelPostResponse();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      color: gradientColor1,
      child: SafeArea(
        child: ListView(children: [
          Stack(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [gradientColor1, gradientColor2],
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.1.h,
                      ),
                      Image.asset(
                        "assets/images/welcome_logo.png",
                        height: 110.h,
                        width: 120.w,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        "Login To \nSTONE WALLET",
                        style: NasalTextStyle.nasal(whiteColor),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: height * 0.03.h,
                      ),
                      Column(
                        children: [
                          Text(
                            "User Name",
                            style: RegularTextStyle.regular16600(whiteColor),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            height: 45.h,
                            padding: EdgeInsets.only(
                                left: width * 0.15.w, right: width * 0.15.w),
                            alignment: Alignment.center,
                            child: TextFormField(
                              readOnly: true,
                              autofocus: true,
                              cursorColor: Colors.blue,
                              controller: userNameController,
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              style: RegularTextStyle.regular16600(whiteColor),
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  borderSide: BorderSide(
                                      color: borderColor, width: 1.0),
                                ),
                                fillColor: fillColor,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  borderSide: BorderSide(
                                      color: borderColor, width: 1.0),
                                ),
                                contentPadding: EdgeInsets.only(left: 20),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Password",
                            style: RegularTextStyle.regular16600(whiteColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 45.h,
                            padding: EdgeInsets.only(
                                left: width * 0.15.w, right: width * 0.15.w),
                            alignment: Alignment.center,
                            child: TextFormField(
                              autofocus: true,
                              cursorColor: Colors.blue,
                              controller: passwordController,
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              style: RegularTextStyle.regular16600(whiteColor),
                              decoration: InputDecoration(
                                // hintText: "Password",
                                hintStyle:
                                    RegularTextStyle.regular16600(cursorColor),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  borderSide: BorderSide(
                                      color: borderColor, width: 1.0),
                                ),
                                fillColor: fillColor,
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  borderSide: BorderSide(
                                      color: borderColor, width: 1.0),
                                ),
                                contentPadding: const EdgeInsets.only(left: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: passwordVisible
                                        ? whiteColor
                                        : greyColor,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () {
                                        passwordVisible = !passwordVisible;
                                      },
                                    );
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Your Password';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              obscureText: passwordVisible,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      SizedBox(
                        height: 45,
                        width: width * 0.50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor3,
                                surfaceTintColor: blackColor,
                                shadowColor: whiteColor,
                                elevation: 4),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (kDebugMode) {
                                  log(userNameController.text);
                                  log(passwordController.text);
                                }

                                var response = await ApiProvider().processLogin(
                                    userNameController.text,
                                    passwordController.text);

                                if (response.message == "Login successful") {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  var snackBar = SnackBar(
                                      content: Text(response.message!));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavigationPage(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                  userController.clear();
                                  passwordController.clear();
                                } else if (response.message ==
                                    " Invalid login credentials") {
                                  var snackBar = SnackBar(
                                      content: Text(response.message!));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  var snackBar = const SnackBar(
                                      content: Text("Something went wrong"));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              }

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context)
                              //   => const BottomNavigationPage()),
                              // );
                            },
                            child: isLoading == true
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text("Login",
                                    textAlign: TextAlign.center,
                                    style:
                                        LargeTextStyle.large20700(textColor))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const ForgetPassword());
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              text: 'Forget Password ?',
                              style: RegularTextStyle.regular15700(whiteColor),
                              children: const <TextSpan>[
                                // TextSpan(
                                //     text: 'bold',
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: blackColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: height * 0.12,
                  left: width * 0.15,
                  child: Image.asset(
                    "assets/Icons/eth.png",
                    height: 25,
                    width: 25,
                  )),
              Positioned(
                  top: height * 0.05,
                  left: width * 0.4,
                  child: Image.asset(
                    "assets/Icons/btc.png",
                    height: 40,
                    width: 40,
                  )),
              Positioned(
                  top: height * 0.25,
                  left: width * 0.8,
                  child: Transform(
                      transform: Matrix4.rotationZ(
                        -3.1415926535897932 / 3,
                      ),
                      child: Image.asset(
                        "assets/Icons/btc.png",
                        height: 34,
                        width: 34,
                      ))),
              Positioned(
                  top: height * 0.22,
                  left: width * 0.07,
                  child: Image.asset(
                    "assets/Icons/iitc.png",
                    height: 35,
                    width: 35,
                  )),
              Positioned(
                  top: height * 0.1,
                  left: width * 0.8,
                  child: Image.asset(
                    "assets/Icons/monero.png",
                    height: 35,
                    width: 35,
                  )),
              Positioned(
                  top: height * 0.8,
                  left: width * 0.1,
                  child: Transform(
                      transform: Matrix4.rotationZ(51),
                      child: Image.asset(
                        "assets/Icons/eth.png",
                        height: 35,
                        width: 25,
                      ))),
              Positioned(
                  top: height * 0.93,
                  left: width * 0.25,
                  child: Transform(
                      transform: Matrix4.rotationZ(30),
                      child: Image.asset(
                        "assets/Icons/monero.png",
                        height: 35,
                        width: 35,
                      ))),
              Positioned(
                  top: height * 0.8,
                  left: width * 0.5,
                  child: Transform(
                      transform: Matrix4.rotationZ(51),
                      child: Image.asset(
                        "assets/Icons/iitc.png",
                        height: 35,
                        width: 35,
                      ))),
              Positioned(
                  top: height * 0.9,
                  left: width * 0.6,
                  child: Transform(
                      transform: Matrix4.rotationZ(100),
                      child: Image.asset(
                        "assets/Icons/iitc.png",
                        height: 25,
                        width: 25,
                      ))),
              Positioned(
                  top: height * 0.85,
                  left: width * 0.8,
                  child: Transform(
                      transform: Matrix4.rotationZ(50),
                      child: Image.asset(
                        "assets/Icons/btc.png",
                        height: 40,
                        width: 40,
                      ))),
            ],
          ),
        ]),
      ),
    ));
  }
}
