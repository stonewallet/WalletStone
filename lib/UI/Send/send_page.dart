import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/send_wallet/send_wallet.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Constants/urls.dart';
import 'package:walletstone/UI/Model/setting/setting_wallet.dart';
import 'package:walletstone/widgets/global.dart';

import '../Constants/colors.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  late TextEditingController walletNameController = TextEditingController();
  late TextEditingController addressController = TextEditingController();
  late TextEditingController passbController = TextEditingController();
  late TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool visibility = false;
  bool isLoading = false;
  late int selectedUserId;
  String selectedUserName = '';
  @override
  void initState() {
    super.initState();
    _getSearch();
    searchController.addListener(onSearchTextControlled);
  }

  List<dynamic> searchList = [];
  TextEditingController searchController = TextEditingController();
  bool isSearchidle = true;
  final focus = FocusNode();
  _getSearch() async {
    try {
      final response = await Dio().get(
        getSettingWallet,
        options: Options(headers: {
          "Cookie":
              "csrftoken=${MySharedPreferences().getCsrfToken(await SharedPreferences.getInstance())}; sessionid=${MySharedPreferences().getSessionId(await SharedPreferences.getInstance())}",
          "X-CSRFToken": MySharedPreferences()
              .getCsrfToken(await SharedPreferences.getInstance())
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        List<GetWallet> searchContent = [];
        for (var searchData in data) {
          if (searchData is Map<String, dynamic> &&
              searchData.containsKey('mnemonic')) {
            GetWallet user = GetWallet.fromJson(searchData);
            searchContent.add(user);
          }
        }

        setState(() {
          searchList = searchContent;
        });
      }

      // List<dynamic> data =
      //     response.data; // Change here to extract the list directly

      // setState(() {
      //   // Update the searchList directly with the fetched data
      //   searchList = data;
      // });
    } catch (error) {
      log('Error fetching suggestions: $error');
      // Handle error
    }
  }

  void onSearchTextControlled() {
    _getSearch();
    setState(() {
      isSearchidle = searchController.text.isEmpty;
      log(isSearchidle.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Widget searchChild(x) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
          child: Text(x, style: RegularTextStyle.regular16600(whiteColor)),
        );
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back_ios,
            color: buttonColor,
            size: 30,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("Send", style: LargeTextStyle.large20700(whiteColor)),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.add_alert,
        //       color: Color(0xff91AFDB),
        //       size: 30,
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context)
        //         => const NotificationPage()),
        //       );
        //     },
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/background_new_wallet.png"),
            fit: BoxFit.fill,
          )),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: 45,
                  width: width * 0.95,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: SearchField(
                    controller: searchController,
                    suggestionDirection: SuggestionDirection.flex,
                    onSearchTextChanged: (query) {
                      final filter = searchList
                          .where((element) => element.mnemonic
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                      return filter
                          .map((e) => SearchFieldListItem<String>(e.mnemonic,
                              child: searchChild(e.mnemonic)))
                          .toList();
                    },
                    onTap: () {},
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: const Key('searchfield'),
                    itemHeight: 50,
                    scrollbarDecoration: ScrollbarDecoration(),
                    onTapOutside: (x) {
                      focus.unfocus();
                    },
                    suggestionStyle: RegularTextStyle.regular16600(whiteColor),
                    searchStyle: RegularTextStyle.regular16600(whiteColor),
                    searchInputDecoration: InputDecoration(
                      hintText: "Wallet Name",
                      hintStyle: RegularTextStyle.regular16600(cursorColor),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                    ),
                    suggestionsDecoration: SuggestionDecoration(
                      color: blackColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    suggestions: searchList
                        .map((e) => SearchFieldListItem<String>(e.mnemonic,
                            child: searchChild(e.mnemonic)))
                        .toList(),
                    focusNode: focus,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Wallet Name';
                      }
                      return null;
                    },
                    suggestionState: Suggestion.expand,
                    onSuggestionTap: (SearchFieldListItem<String>? x) {
                      if (x != null) {
                        final suggestionText = x.searchKey;
                        searchController.text = suggestionText;
                        selectedUserName = suggestionText;
                        selectedUserId = searchList
                            .firstWhere(
                                (element) => element.mnemonic == suggestionText)
                            .id;
                        if (kDebugMode) {
                          log("input - :${searchController.text} get user: $selectedUserName get id :$selectedUserId");
                        }
                      }
                      focus.unfocus();
                    },
                  ),
                ),
                // Container(
                //   height: 45,
                //   width: width * 0.95,
                //   padding: const EdgeInsets.only(left: 15, right: 15),
                //   alignment: Alignment.center,
                //   child: TextField(
                //     autofocus: true,
                //     cursorColor: cursorColor,
                //     controller: walletNameController,
                //     textAlign: TextAlign.start,
                //     textAlignVertical: TextAlignVertical.center,
                //     style: RegularTextStyle.regular16600(whiteColor),
                //     decoration: InputDecoration(
                //       hintText: "Wallet Name",
                //       hintStyle: RegularTextStyle.regular16600(cursorColor),
                //       enabledBorder: const UnderlineInputBorder(
                //         borderSide: BorderSide(color: cursorColor),
                //       ),
                //       focusedBorder: const UnderlineInputBorder(
                //         borderSide: BorderSide(color: cursorColor),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 45,
                  width: width * 0.95,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: TextFormField(
                    autofocus: true,
                    cursorColor: cursorColor,
                    controller: addressController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: RegularTextStyle.regular16600(whiteColor),
                    decoration: InputDecoration(
                      hintText: "Address",
                      hintStyle: RegularTextStyle.regular16600(cursorColor),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 45,
                  width: width * 0.95,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: TextFormField(
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: cursorColor,
                    controller: passbController,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: RegularTextStyle.regular16600(whiteColor),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: RegularTextStyle.regular16600(cursorColor),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Your Password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Container(
                //   height: 45,
                //   width: width * 0.95,
                //   padding: const EdgeInsets.only(left: 15, right: 15),
                //   alignment: Alignment.center,
                //   child: TextField(
                //     autofocus: true,
                //     cursorColor: cursorColor,
                //     controller: usdController,
                //     textAlign: TextAlign.start,
                //     textAlignVertical: TextAlignVertical.center,
                //     style: RegularTextStyle.regular16600(whiteColor),
                //     decoration: InputDecoration(
                //       hintText: "USD",
                //       hintStyle: RegularTextStyle.regular16600(cursorColor),
                //       enabledBorder: const UnderlineInputBorder(
                //         borderSide: BorderSide(color: cursorColor),
                //       ),
                //       focusedBorder: const UnderlineInputBorder(
                //         borderSide: BorderSide(color: cursorColor),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 45,
                  width: width * 0.95,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: TextFormField(
                    autofocus: true,
                    cursorColor: cursorColor,
                    controller: amountController,
                    textAlign: TextAlign.start,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlignVertical: TextAlignVertical.center,
                    style: RegularTextStyle.regular16600(whiteColor),
                    decoration: InputDecoration(
                      hintText: "Amount",
                      hintStyle: RegularTextStyle.regular16600(cursorColor),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cursorColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Your Amount';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Estimated fee:",
                          style: RegularTextStyle.regular16600(whiteColor)),
                      Row(
                        children: [
                          Text("2 % XMR",
                              style: RegularTextStyle.regular16600(whiteColor)),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text("Coin control (optional)",
                //           style: RegularTextStyle.regular16600(whiteColor)),
                //       const Icon(
                //         Icons.arrow_forward_ios,
                //         size: 15,
                //         color: whiteColor,
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Consumer<ApiForSendWallet>(
        builder: (context, value, child) => InkWell(
          onTap: () async {
            //  String formated = t.replace(",", ".");
            if (_formKey.currentState!.validate()) {
              setState(() {
                isLoading = true;
              });
              var response = await value.sendWalletPost(
                selectedUserName,
                passbController.text,
                addressController.text,
                double.parse(amountController.text),
              );
              log(response);
              if (response.message != null) {
                setState(() {
                  isLoading = false;
                });
                Get.back();
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
            }
          },
          child: Container(
            width: width * 0.9,
            height: height * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Add one stop for each color. Stops should increase from 0 to 1
                // stops: [0.1, 0.3, 0.7, 0.9],
                colors: [gradientColor7, gradientColor8],
              ),
            ),
            alignment: Alignment.center,
            child: isLoading == true
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text("Send", style: LargeTextStyle.large20700(whiteColor)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
