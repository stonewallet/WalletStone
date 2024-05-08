import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/API/wallet_balance/wallet_balance.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Constants/urls.dart';
import 'package:walletstone/UI/Model/setting/setting_wallet.dart';
import 'package:walletstone/widgets/customspinkit_widget.dart';

class DropDownTextFieldWidget extends StatefulWidget {
  final List<GetWallet> dropDownList;

  final Function(GetWallet) onWalletSelected;

  const DropDownTextFieldWidget({
    Key? key,
    required this.dropDownList,
    required this.onWalletSelected,
  }) : super(key: key);

  @override
  State<DropDownTextFieldWidget> createState() =>
      _DropDownTextFieldWidgetState();
}

class _DropDownTextFieldWidgetState extends State<DropDownTextFieldWidget> {
  TextEditingController balanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
      print('Error fetching suggestions: $error');
      // Handle error
    }
  }

  void onSearchTextControlled() {
    _getSearch();
    setState(() {
      isSearchidle = searchController.text.isEmpty;
      print(isSearchidle);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget searchChild(x) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
          child: Text(x, style: RegularTextStyle.regular16600(whiteColor)),
        );
    return SizedBox(
      height: 50,
      width: MediaQuery.sizeOf(context).width / 2.5,
      child: SizedBox(
        height: 100,
        child: SearchField(
          controller: searchController,
          maxSuggestionsInViewPort: 10,
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
              hintText: "My Wallets",
              hintStyle: RegularTextStyle.regular16600(cursorColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: cursorColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: cursorColor),
              ),
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
                size: 25,
                color: whiteColor,
              )),
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
                  .firstWhere((element) => element.mnemonic == suggestionText)
                  .id;
              _showSelectedWalletAlert(suggestionText);
              if (kDebugMode) {
                print(
                    "input - :${searchController.text} get user: $selectedUserName get id :$selectedUserId");
              }
            }
            focus.unfocus();
          },
        ),
      ),
    );
  }

  void _showSelectedWalletAlert(wallet) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: buttonColor3,
              title: Text(
                "Selected Wallet",
                style: RegularTextStyle.regular18600(whiteColor),
              ),
              content: Text(
                "You have selected: ${wallet}",
                style: RegularTextStyle.regular16bold(whiteColor),
              ),
              actions: [
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      cursorColor: cursorColor,
                      controller: balanceController,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          color: whiteColor, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        hintStyle: RegularTextStyle.regular15400(whiteColor),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: cursorColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: cursorColor),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: gradientColor1,
                      foregroundColor: gradientColor1,
                      shadowColor: whiteColor,
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      elevation: 4,
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              final balanceProvider =
                                  Provider.of<ApiWalletBalance>(context,
                                      listen: false);
                              var response =
                                  await balanceProvider.getWalletBalance(
                                mnemonic: wallet,
                                password: balanceController.text,
                              );
                              if (balanceController.text.isEmpty) {
                                setState(
                                  () {
                                    isLoading = false;
                                  },
                                );
                              }
                              if (response != null) {
                                setState(() {
                                  isLoading = false;
                                });
                                Get.close(1);
                                _showAlertBox(wallet);
                                balanceController.clear();
                              }
                            }
                          },
                    child: isLoading
                        ? const CustomSpinKitFadingCube(
                            color: whiteColor,
                            size: 22,
                          )
                        : const Text("OK"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAlertBox(walletResponse) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CupertinoAlertDialog(
              title: Text("Your Selected Wallet:\n"
                  "$walletResponse"),
              content: Consumer<ApiWalletBalance>(
                builder: (context, value, child) => Text(
                  "And Your Balance is:\n"
                  "${value.value}",
                  style: RegularTextStyle.regular15600(blackColor),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: blackColor.withOpacity(0.01),
                    //     surfaceTintColor: blackColor,
                    //     shadowColor: whiteColor,
                    //     shape: const BeveledRectangleBorder(),
                    //     elevation: 4,
                    //   ),
                    //   onPressed: () {
                    //     Get.close(2);
                    //   },
                    //   child: const Text("Copy"),
                    // ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blackColor.withOpacity(0.01),
                        surfaceTintColor: blackColor,
                        foregroundColor: gradientColor1,
                        shadowColor: whiteColor,
                        shape: const ContinuousRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Get.close(1);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
