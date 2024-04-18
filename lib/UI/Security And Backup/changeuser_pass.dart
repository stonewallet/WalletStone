import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/change_password/change_user_password.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import '../Constants/colors.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  TextEditingController oldPasswordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();

  TextEditingController conifirmPasswordController = TextEditingController();
  bool button = false;

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
        title: Text("Change Password",
            style: LargeTextStyle.large20700(whiteColor)),
        // actions: [
        //   TextButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => const EditBackupPasswordPage()),
        //         );
        //       },
        //       child: Text("Change password",
        //           style: RegularTextStyle.regular14600(blueAccentColor)))
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.01,
            ),
            // Text("Change password",
            //     style: LargeTextStyle.large20700(whiteColor)),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 45,
              width: width * 0.95,
              padding: const EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              child: TextField(
                autofocus: true,
                cursorColor: cursorColor,
                controller: oldPasswordController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: RegularTextStyle.regular16bold(whiteColor),
                decoration: InputDecoration(
                  hintText: "Old Password",
                  hintStyle: RegularTextStyle.regular16bold(cursorColor),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: cursorColor),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: cursorColor),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 45,
              width: width * 0.95,
              padding: const EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              child: TextField(
                autofocus: true,
                cursorColor: cursorColor,
                controller: newPasswordController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: RegularTextStyle.regular16bold(whiteColor),
                decoration: InputDecoration(
                  hintText: "New password",
                  hintStyle: RegularTextStyle.regular16bold(cursorColor),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: cursorColor),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: cursorColor),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 45,
              width: width * 0.95,
              padding: const EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              child: TextField(
                autofocus: true,
                cursorColor: cursorColor,
                controller: conifirmPasswordController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: RegularTextStyle.regular16bold(whiteColor),
                decoration: InputDecoration(
                  hintText: "Confirm paswword",
                  hintStyle: RegularTextStyle.regular16bold(cursorColor),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: cursorColor),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: cursorColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<ApiChangePassword>(
        builder: (context, value, child) => SizedBox(
          width: width * 0.8,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor2,
                surfaceTintColor: blackColor,
                shadowColor: whiteColor,
                elevation: 4),
            onPressed: () async {
              var response = await value.changeUserPass(
                old: oldPasswordController.text,
                newPass: newPasswordController.text,
                confirm: conifirmPasswordController.text,
              );
              if (response.message != null) {
                Get.back();
                Get.snackbar(
                  "Password Changed successfully",
                  '',
                  backgroundColor: newGradient6,
                  colorText: whiteColor,
                  padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                  duration: const Duration(milliseconds: 4000),
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                Get.snackbar(
                  "Something Went Wrong",
                  '',
                  backgroundColor: newGradient6,
                  colorText: whiteColor,
                  padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                  duration: const Duration(milliseconds: 4000),
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: Text("Change Password",
                style: RegularTextStyle.regular18600(whiteColor)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
