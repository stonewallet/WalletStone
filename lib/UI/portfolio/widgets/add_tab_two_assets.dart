import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/add_assets/add_assets.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Model/portfolio/portfolio_model.dart' as port;
import 'package:walletstone/UI/portfolio/controller/asset_provider.dart';
import 'package:walletstone/UI/portfolio/controller/assets_controller.dart';
import 'package:walletstone/UI/portfolio/controller/cash_controller.dart';
import 'package:walletstone/UI/portfolio/controller/portfolip_controller.dart';
import 'package:walletstone/widgets/global.dart';

class TabTwoAssets extends StatefulWidget {
  final RxList<port.Portfolio> assetsportfolio;

  final int _portfolio;
  final String centerTitle;
  const TabTwoAssets(this.assetsportfolio, this._portfolio,
      {super.key, required this.centerTitle});

  @override
  State<TabTwoAssets> createState() => TabTwoAssetsState();
}

class TabTwoAssetsState extends State<TabTwoAssets> {
  // List<TravelList> travelList = <TravelList>[];
  bool isSwitch = true;
  bool isLoading = false;

  TextEditingController assestNameController = TextEditingController();
  TextEditingController assestAmountController = TextEditingController();

  final controller = Get.put(PortfolioController2());

  final cryptocontroller = Get.put(PortfolioController());

  final cashcontroller = Get.put(PortfolioController3());
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    log(widget._portfolio.toString());
    return Scaffold(
        backgroundColor: Colors.transparent,
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
        ),
        body: SingleChildScrollView(
          child: Container(
              width: width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/background_new_wallet.png"),
                fit: BoxFit.fill,
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Container(
                    width: width,
                    height: height,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [newGradient5, newGradient6],
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(widget.centerTitle,
                            style: LargeTextStyle.large20700(whiteColor)),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: width * 0.4,
                          height: 2,
                          color: lineColor,
                        ),
                        Container(
                          width: width * 0.9,
                          height: 1,
                          color: lineColor2,
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // const SizedBox(height: 30,),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Assets Name",
                                      style: RegularTextStyle.regular16600(
                                          Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    SizedBox(
                                      height: 60,
                                      width: width,
                                      // padding: EdgeInsets.only(left: 15, right: 15),
                                      // alignment: Alignment.center,
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        autofocus: true,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        cursorColor: Colors.blue,
                                        controller: assestNameController,
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: RegularTextStyle.regular16600(
                                            whiteColor),
                                        decoration: InputDecoration(
                                          // focusedBorder: const OutlineInputBorder(
                                          //   borderRadius: BorderRadius.all(
                                          //       Radius.circular(1)),
                                          //   borderSide: BorderSide(
                                          //       color: borderColor, width: 1.0),
                                          // ),
                                          fillColor: fillColor,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: blueAccentColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: blueAccentColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: borderColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          errorStyle:
                                              const TextStyle(height: 0),
                                          errorMaxLines: 1,
                                          contentPadding:
                                              const EdgeInsets.only(left: 7),
                                        ),
                                        textInputAction: TextInputAction.next,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Assets Amount",
                                        style: RegularTextStyle.regular16600(
                                            Colors.white)),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    SizedBox(
                                      height: 60,
                                      width: width,
                                      // padding: EdgeInsets.only(left: 15, right: 15),
                                      // alignment: Alignment.center,
                                      child: TextFormField(
                                        autofocus: true,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        cursorColor: Colors.blue,
                                        controller: assestAmountController,
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: RegularTextStyle.regular16600(
                                            whiteColor),
                                        decoration: InputDecoration(
                                          // focusedBorder: const OutlineInputBorder(
                                          //   borderRadius: BorderRadius.all(
                                          //       Radius.circular(1)),
                                          //   borderSide: BorderSide(
                                          //       color: borderColor, width: 1.0),
                                          // ),
                                          fillColor: fillColor,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: blueAccentColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: blueAccentColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: borderColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          errorStyle:
                                              const TextStyle(height: 0),
                                          errorMaxLines: 1,
                                          contentPadding:
                                              const EdgeInsets.only(left: 7),
                                        ),
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Amount';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: SizedBox(
                                  height: 45,
                                  width: width * 0.6,
                                  child: Consumer<AssetProvider>(
                                    builder: (context, value, child) =>
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: buttonColor2,
                                                surfaceTintColor: blackColor,
                                                shadowColor: whiteColor,
                                                elevation: 4),
                                            onPressed: () async {
                                              //  List <Map<String, dynamic>> productList = [];

                                              //                                     List<Map<String, dynamic>> expensesList =
                                              //                                         [];

                                              // // Add assets from assetsportfolio
                                              // expensesList.addAll(widget.assetsportfolio.map((asset) => {
                                              //   "coin_name": asset.coinName,
                                              //   "quantity": asset.quantity,
                                              //   "sub_cat": asset.subCat,
                                              // }));

                                              // // Add assets from cashportfolio
                                              // expensesList.addAll(widget.cashPortfolio.map((asset) => {
                                              //   "coin_name": asset.coinName,
                                              //   "quantity": asset.quantity,
                                              //   "sub_cat": asset.subCat,
                                              // }));

                                              // // Add assets from portfolio
                                              // expensesList.addAll(widget.portfolio.map((asset) => {
                                              //   "coin_name": asset.coinName,
                                              //   "quantity": asset.quantity,
                                              //   "sub_cat": asset.subCat,
                                              // }));
                                              // for (int i = 0;
                                              //     i <=
                                              //         widget.assetsportfolio.length - 1;
                                              //     i++) {
                                              //   expensesList.add({
                                              //     "coin_name": widget
                                              //         .assetsportfolio[i].coinName,
                                              //     "quantity": widget
                                              //         .assetsportfolio[i].quantity,
                                              //     "sub_cat":
                                              //         widget.assetsportfolio[i].subCat,
                                              //   });
                                              // }
                                              // for (int i = 0;
                                              //     i <= widget.cashPortfolio.length - 1;
                                              //     i++) {
                                              //   expensesList.add({
                                              //     "coin_name":
                                              //         widget.cashPortfolio[i].coinName,
                                              //     "quantity":
                                              //         widget.cashPortfolio[i].quantity,
                                              //     "sub_cat":
                                              //         widget.cashPortfolio[i].subCat,
                                              //   });
                                              // }
                                              // for (int i = 0;
                                              //     i <= widget.portfolio.length - 1;
                                              //     i++) {
                                              //   expensesList.add({
                                              //     "coin_name":
                                              //         widget.portfolio[i].coinName,
                                              //     "quantity":
                                              //         widget.portfolio[i].quantity,
                                              //     "sub_cat": widget.portfolio[i].subCat,
                                              //   });
                                              // }

                                              // expensesList.add({
                                              //   "coin_name": assestNameController.text,
                                              //   "quantity": double.parse(
                                              //       assestAmountController.text),
                                              //   "sub_cat": widget._portfolio,
                                              // });
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                // Call the API service to add the asset
                                                // await ApiServiceForADDAssets().addAsset(
                                                //   expensesList
                                                // );
                                                if (kDebugMode) {
                                                  log(widget._portfolio.toString());
                                                }

                                                var response =
                                                    await ApiServiceForADDAssets()
                                                        .addAsset(
                                                  assestNameController.text,
                                                  double.parse(
                                                      assestAmountController
                                                          .text),
                                                  widget._portfolio,
                                                );
                                                controller.update();
                                                cryptocontroller.update();
                                                cashcontroller.update();
                                                // Handle each emitted response here
                                                value.getAsset();
                                                if (response.message != null) {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  Get.back();
                                                  alert(response.message!);
                                                } else {
                                                  // Handle errors that occur during stream processing

                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  var snackBar = const SnackBar(
                                                      content: Text(
                                                          "Something gone wrong"));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);

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
                                            child: isLoading == true
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text("Add Assets",
                                                    textAlign: TextAlign.center,
                                                    style: RegularTextStyle
                                                        .regular14600(
                                                            whiteColor))),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
