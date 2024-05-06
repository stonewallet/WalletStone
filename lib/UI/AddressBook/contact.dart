import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/contact/post_contact.dart';

import '../Constants/colors.dart';
import '../Constants/text_styles.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  TextEditingController contactNameController = TextEditingController();
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
        title: Text("Contact", style: LargeTextStyle.large20700(whiteColor)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: height * 0.02,
          ),

          Form(
            key: _formKey,
            child: Container(
              height: 45,
              width: width * 0.95,
              padding: const EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              child: TextFormField(
                autofocus: true,
                cursorColor: cursorColor,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: contactNameController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: RegularTextStyle.regular16bold(whiteColor),
                decoration: InputDecoration(
                  hintText: "Contact Name",
                  hintStyle: RegularTextStyle.regular16bold(cursorColor),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: cursorColor),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: cursorColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Name';
                  }
                  return null;
                },
              ),
            ),
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
            // SizedBox(
            //   width: width * 0.4,
            //   child: ElevatedButton(
            //       style:
            //           ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            //       onPressed: () {},
            //       child: Text(
            //         "Reset",
            //         style: RegularTextStyle.regular18600(whiteColor),
            //       )),
            // ),
            SizedBox(
              width: width * 0.4,
              child: Consumer<ApiServiceForContact>(
                builder: (context, value, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var response =
                            await value.addContact(contactNameController.text);
                        if (response.message != null) {
                          value.getContact();
                          Get.back();
                        }
                      }
                    },
                    child: Text(
                      "Save",
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
