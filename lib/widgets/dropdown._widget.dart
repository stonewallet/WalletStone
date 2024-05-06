import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/wallet_balance/wallet_balance.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
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
  GetWallet? _selectedWallet;
  TextEditingController balanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _selectedWallet = null;
  }

  @override
  void dispose() {
    // balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.sizeOf(context).width / 3.2,
      child: SizedBox(
        height: 50,
        child: DropdownButtonFormField<GetWallet>(
          alignment: AlignmentDirectional.topStart,
          value: _selectedWallet,
          iconSize: 24,
          iconEnabledColor: whiteColor,
          elevation: 0,
          dropdownColor: gradientColor1,
          style: const TextStyle(
            color: whiteColor,
          ),
          hint: Text(
            "      My Wallet",
            style: RegularTextStyle.regular14600(whiteColor),
            textAlign: TextAlign.center,
          ),
          decoration: const InputDecoration(
              hintTextDirection: TextDirection.ltr,
              disabledBorder: InputBorder.none,
              hintStyle: TextStyle(
                color: whiteColor,
              )),
          items: widget.dropDownList.map((GetWallet wallet) {
            return DropdownMenuItem<GetWallet>(
              value: wallet,
              child: Text(
                wallet.mnemonic!,
                style: RegularTextStyle.regular14600(whiteColor),
              ),
            );
          }).toList(),
          onChanged: (GetWallet? newValue) {
            setState(() {
              _selectedWallet = newValue;
              if (newValue != null) {
                widget.onWalletSelected(newValue);
                _showSelectedWalletAlert(_selectedWallet!);
              }
            });
          },
        ),
      ),
    );
  }

  void _showSelectedWalletAlert(GetWallet wallet) {
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
                "You have selected: ${wallet.mnemonic}",
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
                                mnemonic: wallet.mnemonic!,
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

  void _showAlertBox(GetWallet walletResponse) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CupertinoAlertDialog(
              title: Text("Your Selected Wallet:\n"
                  "${walletResponse.mnemonic}"),
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
