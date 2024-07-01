import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/forget_password/forget_password.dart';
import 'package:walletstone/Responses/travel_post_response.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/strings.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Home/home_page.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  TravelPostResponse travelPostResponse = TravelPostResponse();

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
              Container(
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
                      height: height * 0.2,
                    ),
                    Image.asset(
                      "assets/images/welcome_logo.png",
                      height: 110,
                      width: 120,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      "Enter Your \nUserName",
                      style: NasalTextStyle.nasal(whiteColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Column(
                      children: [
                        Text(
                          "User Name",
                          style: RegularTextStyle.regular16600(whiteColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            height: 45,
                            padding: EdgeInsets.only(
                                left: width * 0.15, right: width * 0.15),
                            alignment: Alignment.center,
                            child: TextFormField(
                              autofocus: true,
                              cursorColor: Colors.blue,
                              controller: userNameController,
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              style: RegularTextStyle.regular16600(whiteColor),
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: borderColor, width: 1.0),
                                ),
                                fillColor: fillColor,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: borderColor, width: 1.0),
                                ),
                                contentPadding: EdgeInsets.only(left: 20),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter UserName';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 65,
                      width: width * 0.75,
                      child: Consumer<ApiForgetPassword>(
                        builder: (context, value, child) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor3,
                                surfaceTintColor: blackColor,
                                shadowColor: whiteColor,
                                elevation: 4),
                            onPressed: () async {
                              // final SharedPreferences sharedPref =
                              //     await SharedPreferences.getInstance();
                              if (_formKey.currentState!.validate()) {
                                if (kDebugMode) {
                                  log(userNameController.text);
                                  // log(passwordController.text);
                                }
                                // sharedPref.setString(
                                //     "name", userNameController.text);
                                // var response = await ApiProvider().processLogin(
                                //     userNameController.text,
                                //     passwordController.text);
                                var response = await value.forgetPassword(
                                    userName: userNameController.text);

                                if (response.message == "Login successful") {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  var snackBar = SnackBar(
                                      content: Text(response.message!));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavigationPage()),
                                    );
                                  }
                                  userNameController.clear();
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
                                : Text("Send",
                                    textAlign: TextAlign.center,
                                    style:
                                        LargeTextStyle.large20700(textColor))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'You will receive a mail to\n'
                      '   recover your Account',
                      style: RegularTextStyle.regular15400(greyColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    ));
  }
}
