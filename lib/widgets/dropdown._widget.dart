import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    _selectedWallet = widget.dropDownList[0];
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
      child: Form(
        key: _formKey,
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
            return CupertinoAlertDialog(
              title: const Text("Selected Wallet"),
              content: Text("You have selected: ${wallet.mnemonic}"),
              actions: [
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: CupertinoTextField(
                    controller: balanceController,
                    autofocus: true,
                    cursorColor: cursorColor,
                    decoration:
                        BoxDecoration(color: whiteColor.withOpacity(0.5)),
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: RegularTextStyle.regular16bold(blackColor),
                    placeholder: 'Enter Password',
                    placeholderStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: CupertinoColors.placeholderText,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blackColor.withOpacity(0.01),
                    surfaceTintColor: blackColor,
                    shadowColor: whiteColor,
                    shape: const BeveledRectangleBorder(),
                    elevation: 4,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          final balanceProvider = Provider.of<ApiWalletBalance>(
                              context,
                              listen: false);
                          var response = await balanceProvider.getWalletBalance(
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
                            Get.back();
                            balanceController.clear();
                          }
                        },
                  child: isLoading
                      ? const CustomSpinKitFadingCube(
                          color: gradientColor1,
                          size: 22,
                        )
                      : const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
