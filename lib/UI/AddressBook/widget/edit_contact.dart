import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/contact/post_contact.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Model/contact/contact.dart';

class EditContactPage extends StatefulWidget {
  const EditContactPage({super.key, required this.contacts});
  final Contacts contacts;

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late TextEditingController contactNameController;
  TextEditingController currencyController = TextEditingController();

  @override
  void initState() {
    contactNameController =
        TextEditingController(text: widget.contacts.contactName!);
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
        title:
            Text("Edit Contact", style: LargeTextStyle.large20700(whiteColor)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            height: 45,
            width: width * 0.95,
            padding: const EdgeInsets.only(left: 15, right: 15),
            alignment: Alignment.center,
            child: TextField(
              autofocus: true,
              cursorColor: cursorColor,
              controller: contactNameController,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              style: RegularTextStyle.regular16bold(whiteColor),
              decoration: InputDecoration(
                labelStyle: RegularTextStyle.regular16bold(whiteColor),
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
            height: 15,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.4,
              child: Consumer<ApiServiceForContact>(
                builder: (context, value, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    onPressed: () async {
                      var response = await value.editContact(
                        name: contactNameController.text,
                        iD: widget.contacts.id!,
                        user: widget.contacts.user!,
                      );
                      if (response != false) {
                        value.getContact();
                        Get.back();
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
