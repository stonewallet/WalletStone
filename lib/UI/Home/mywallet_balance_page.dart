import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/homeServices/homecoins.dart';
import 'package:walletstone/API/receive_address/receive_address.dart';
import 'package:walletstone/API/settingwallet/get_setting_wallet.dart';
import 'package:walletstone/API/wallet_balance/wallet_balance.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Model/homeCoin/home_coin_model.dart';
import 'package:walletstone/UI/Model/setting/setting_wallet.dart';
import 'package:walletstone/widgets/dropdown._widget.dart';
import '../../API/shared_preferences.dart';
import '../Constants/colors.dart';
import '../Model/coin_model.dart';
import '../Send/send_page.dart';

class MyWalletBalancePage extends StatefulWidget {
  const MyWalletBalancePage({super.key});

  @override
  State<MyWalletBalancePage> createState() => _MyWalletBalancePageState();
}

class _MyWalletBalancePageState extends State<MyWalletBalancePage> {
  bool selectCoins = true;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  List<CoinModel> coinsList = [
    CoinModel(
        name: "BTC",
        type: "Bitcoin",
        icon: "assets/Icons/Bitcoin.svg.png",
        amount: "1 BTC",
        usdAmount: "\$10,504"),
    CoinModel(
        name: "ETH",
        type: "Ethereum",
        icon: "assets/Icons/ethereum.png",
        amount: "1 ETH",
        usdAmount: "\$4879.6"),
    CoinModel(
        name: "USDT",
        type: "TetherUS",
        icon: "assets/Icons/tether.png",
        amount: "1 USDT",
        usdAmount: "\$60.60"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1 Solana",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1 XRP",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
    CoinModel(
        name: "XRP",
        type: "Ripple",
        icon: "assets/Icons/ripple.png",
        amount: "1",
        usdAmount: "\$1240"),
  ];

  late ApiServiceForGetSettingWallets apiServiceForGetSettingWallets;
  late ApiServiceForHomeCoins apiServiceForHomeCoins;

  @override
  void initState() {
    apiServiceForHomeCoins = ApiServiceForHomeCoins();
    apiServiceForGetSettingWallets = ApiServiceForGetSettingWallets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.001,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text('My Wallet',
              //         textAlign: TextAlign.center,
              //         style: RegularTextStyle.regular15600(termsColor)),
              //     const Icon(
              //       Icons.arrow_drop_down,
              //       color: termsColor,
              //     )
              //   ],
              // ),
              FutureBuilder<List<GetWallet>>(
                future:
                    apiServiceForGetSettingWallets.getDataForSettingWallet(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No data",
                        style: LargeTextStyle.large18800(whiteColor),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        "No data",
                        style: LargeTextStyle.large18800(whiteColor),
                      ),
                    );
                  } else {
                    final List<GetWallet> wallets = snapshot.data!;
                    // final List<DropDownValueModel> dropDownList = wallets
                    //     .map((wallet) => DropDownValueModel(
                    //         name: wallet.mnemonic!, value: wallet.mnemonic))
                    //     .toList();

                    return DropDownTextFieldWidget(
                        dropDownList: wallets,
                        onWalletSelected: (GetWallet selectedWallet) {});
                  }
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              // Consumer<ApiWalletBalance>(
              //   builder: (context, value, child) => Text(
              //       'Balance :${value.value}',
              //       textAlign: TextAlign.center,
              //       style: RegularTextStyle.regular15600(whiteColor)),
              // ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor4,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20)),
                          onPressed: () async {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context)
                            //   => const ReceivePage()),
                            // );
                            print(MySharedPreferences().getCsrfToken(
                                await SharedPreferences.getInstance()));
                            print(MySharedPreferences().getSessionId(
                                await SharedPreferences.getInstance()));
                            _showBottomSheet();
                          },
                          child: Image.asset("assets/Icons/download.png",
                              width: 25, height: 25, color: whiteColor)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Receive",
                          style: RegularTextStyle.regular15600(whiteColor))
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor4,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SendPage()),
                            );
                          },
                          child: Image.asset(
                            "assets/Icons/upload.png",
                            width: 25,
                            height: 25,
                            color: whiteColor,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Send",
                          style: RegularTextStyle.regular15600(whiteColor))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      border: Border.all(color: whiteColor),
                      color: whiteColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      border: Border.all(color: whiteColor),
                      color: whiteColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      // begin: Alignment(0.00, -1.00),
                      // end: Alignment(0, 1),
                      colors: [newGradient5, newGradient6],
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Column(
                            children: [
                              Text("Coins",
                                  style: RegularTextStyle.regular15600(
                                      whiteColor)),
                              const SizedBox(
                                height: 3,
                              ),
                              selectCoins
                                  ? Container(
                                      width: width * 0.2,
                                      height: 3,
                                      color: lineColor,
                                    )
                                  : Container()
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              selectCoins = true;
                            });
                          },
                        ),
                        SizedBox(
                          width: width * 0.2,
                        ),
                        GestureDetector(
                          child: Column(
                            children: [
                              Text("Transactions",
                                  style: RegularTextStyle.regular15600(
                                      whiteColor)),
                              const SizedBox(
                                height: 3,
                              ),
                              !selectCoins
                                  ? Container(
                                      width: width * 0.2,
                                      height: 3,
                                      color: lineColor,
                                    )
                                  : Container()
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              selectCoins = false;
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: width * 0.9,
                      height: 1,
                      color: lineColor2,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(
                          left: width * 0.05, right: width * 0.05),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: searchController,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        style: RegularTextStyle.regular14600(whiteColor),
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(color: textfieldColor, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(color: textfieldColor, width: 1.0),
                          ),
                          filled: true,
                          fillColor: textfieldColor,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: hintColor,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    selectCoins == true
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: width * 0.06),
                                    child: Text('Name',
                                        style: RegularTextStyle.regular15600(
                                            whiteColor)),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: width * 0.06),
                                    child: Text('Holdings',
                                        style: RegularTextStyle.regular15600(
                                            whiteColor)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                  child: FutureBuilder<List<HomeCoin>>(
                                      future: apiServiceForHomeCoins
                                          .getDataForHomeCoins(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.data == null ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                            child: Text(
                                              "No data",
                                              style: LargeTextStyle.large18800(
                                                  whiteColor),
                                            ),
                                          );
                                        } else if (!snapshot.hasData) {
                                          return Center(
                                            child: Text(
                                              "No data",
                                              style: LargeTextStyle.large18800(
                                                  whiteColor),
                                            ),
                                          );
                                        } else {
                                          final List<HomeCoin> coins =
                                              snapshot.data!;

                                          return ListView.builder(
                                            key: UniqueKey(),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                color: Colors.transparent,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.05,
                                                        ),
                                                        SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child: Image.network(
                                                            'https://www.${coins[index].imageUrl}',
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                            coins[index]
                                                                .coinName,
                                                            style: RegularTextStyle
                                                                .regular15600(
                                                                    whiteColor)),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                coinsList[index]
                                                                    .amount,
                                                                style: RegularTextStyle
                                                                    .regular15600(
                                                                        whiteColor)),
                                                            Text(
                                                                "\$ ${coins[index].coinPrice.toStringAsFixed(3)}",
                                                                style: RegularTextStyle
                                                                    .regular15600(
                                                                        greenAccentColor)),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.05,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: coins.length,
                                          );
                                        }
                                      }))
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: width * 0.06),
                                    child: Text('Name',
                                        style: RegularTextStyle.regular15600(
                                            whiteColor)),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: width * 0.06),
                                    child: Text('Amount',
                                        style: RegularTextStyle.regular15600(
                                            whiteColor)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: height * 0.4,
                                child: ListView.builder(
                                  key: UniqueKey(),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: width * 0.05,
                                              ),
                                              Text(
                                                  "${coinsList[index].name}  (${coinsList[index].type})",
                                                  style: RegularTextStyle
                                                      .regular15600(
                                                          whiteColor)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(coinsList[index].amount,
                                                      style: RegularTextStyle
                                                          .regular15600(
                                                              whiteColor)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: width * 0.05,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: 2,
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: gradientColor1,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter Wallet Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Container(
                    height: 45,
                    width: MediaQuery.sizeOf(context).width * 0.95,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    alignment: Alignment.center,
                    child: TextFormField(
                      autofocus: true,
                      cursorColor: cursorColor,
                      controller: _textController,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          color: whiteColor, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Enter Wallet Name",
                        hintStyle: RegularTextStyle.regular16600(whiteColor),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: cursorColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: cursorColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some data';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Consumer<ApiPublicAddress>(
                  builder: (context, value, child) => ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (kDebugMode) {
                          print('Entered data: ${_textController.text}');
                        }
                        final String text = _textController.text.trim();
                        var response =
                            await value.getPublicAddress(mnemonic: text);
                        // var snackBar = SnackBar(content: Text(response!));
                        // if (context.mounted) {
                        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // }
                        if (response != null) {
                          _showAlertBox(response);
                          _textController.clear();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlertBox(String response) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CupertinoAlertDialog(
              title: const Text("Public Address"),
              content: Text(response),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blackColor.withOpacity(0.01),
                        surfaceTintColor: blackColor,
                        shadowColor: whiteColor,
                        shape: const BeveledRectangleBorder(),
                        elevation: 4,
                      ),
                      onPressed: () {
                        copyFile(response);
                        Get.close(2);
                      },
                      child: const Text("Copy"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blackColor.withOpacity(0.01),
                        surfaceTintColor: blackColor,
                        shadowColor: whiteColor,
                        shape: const BeveledRectangleBorder(),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Get.close(2);
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

  copyFile(String response) async {
    Clipboard.setData(ClipboardData(text: response)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("your Address copied to clipboard")));
    });
  }
}



/*
DropdownButtonFormField<GetWallet>(
      value: _selectedWallet,
      iconSize: 0,
      decoration: const InputDecoration(
          hintText: 'Select',
          hintTextDirection: TextDirection.ltr,
          hintStyle: TextStyle(
            color: whiteColor,
          )),
      items: widget.dropDownList.map((GetWallet wallet) {
        return DropdownMenuItem<GetWallet>(
          value: wallet,
          child: Text(wallet.mnemonic),
        );
      }).toList(),
      onChanged: (GetWallet? newValue) {
        setState(() {
          _selectedWallet = newValue;
          if (newValue != null) {
            widget.onWalletSelected(newValue);
          }
        });
      },
      
    );



    DropDownTextField(
            textStyle: const TextStyle(color: whiteColor),
            textFieldDecoration: const InputDecoration(
                hintText: ' Wallet', hintStyle: TextStyle(color: whiteColor)),
            controller: _controller,
            clearOption: false,
            dropDownItemCount: 6,
            dropDownList: widget.dropDownList,
            onChanged: (val) {
              setState(() {
                // _selectedWallet = val;
                _selectedWallet = GetWallet(mnemonic: val!.value);
              });
              widget.onWalletSelected(_selectedWallet!);
              // _showSelectedWalletAlert(_selectedWallet!);
            },
          ),
 */