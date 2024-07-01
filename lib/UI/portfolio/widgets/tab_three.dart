import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/portfolio_api/api_services.dart';
import 'package:walletstone/API/portfolio_api/search_api.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Model/portfolio/search_model.dart';
import 'package:walletstone/UI/portfolio/controller/asset_provider.dart';
import 'package:walletstone/UI/portfolio/controller/cash_controller.dart';
import 'package:walletstone/UI/portfolio/widgets/add_tab_three_assets.dart';
import 'package:walletstone/UI/portfolio/widgets/updateanddelete_assets.dart';

class TabBarScreenThree extends StatefulWidget {
  const TabBarScreenThree({super.key});

  @override
  State<TabBarScreenThree> createState() => _TabBarScreenThreeState();
}

class _TabBarScreenThreeState extends State<TabBarScreenThree> {
  late TextEditingController searchController = TextEditingController();

  late ApiService apiService;
  int _portfolio = 2;
  List<SearchData> searchList = [];
  bool isSearchidle = true;
  final cashcontroller = Get.put(PortfolioController3());
  // final assetsController = Get.put(PortfolioController2());
  // final cashController = Get.put(PortfolioController3());
  late double width;
  late double height;

  @override
  void initState() {
    apiService = ApiService();
    super.initState();
    _getSearch();
    searchController.addListener(onSearchTextControlled);
    Provider.of<AssetProvider>(context, listen: false).getCash();
  }

  _getSearch() async {
    try {
      searchList = await SearchApi()
          .getSearchData(searchController.text.trim(), _portfolio);
    } catch (error) {
      // Handle error
      log('Error in _getSearch: $error');
    }
  }

  void onSearchTextControlled() {
    _getSearch();
    setState(() {
      isSearchidle = searchController.text.isEmpty;
      log(isSearchidle.toString());
    });
  }

  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width.w;
    height = MediaQuery.of(context).size.height.h;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(child: GetBuilder<PortfolioController3>(
          builder: (controller) {
            Widget body;

            if (searchController.text.isEmpty) {
              body = buildContentWidget(width);
            } else {
              if (searchList.isEmpty) {
                body = Text(
                  "No results found",
                  style: RegularTextStyle.regular18600(whiteColor),
                );
              } else {
                body = buildSearchResults(width);
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.02,
                ),

                // SizedBox(
                //   height: height * 0.04,
                // ),
                // PieChart(
                //   dataMap: controller.dataMap,
                //   animationDuration: const Duration(milliseconds: 800),
                //   chartLegendSpacing: 35,
                //   chartRadius: MediaQuery.of(context).size.width / 3.2,
                //   colorList: colorList,
                //   initialAngleInDegree: 0,
                //   chartType: ChartType.ring,
                //   ringStrokeWidth: 32,
                //   legendOptions: LegendOptions(
                //     showLegendsInRow: false,
                //     legendPosition: LegendPosition.right,
                //     showLegends: true,
                //     legendShape: BoxShape.circle,
                //     legendTextStyle:
                //         RegularTextStyle.regular16bold(whiteColor),
                //   ),
                //   chartValuesOptions: const ChartValuesOptions(
                //     showChartValues: false,
                //     showChartValuesInPercentage: false,
                //     showChartValuesOutside: false,
                //     decimalPlaces: 0,
                //   ),
                // ),

                // Image.asset("assets/Icons/Group81.png"),
                SizedBox(
                  height: height * 0.00001,
                ),
                Container(
                  height: 50,
                  padding:
                      EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: searchController,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: RegularTextStyle.regular14400(whiteColor),
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide:
                            BorderSide(color: textfieldColor, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide:
                            BorderSide(color: textfieldColor, width: 1.0),
                      ),
                      hintText: "Browse",
                      hintStyle: RegularTextStyle.regular14400(hintColor),
                      filled: true,
                      fillColor: textfieldColor,
                      prefixIcon: const Icon(
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
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: width * 0.06),
                          child: Text('Cash',
                              style: RegularTextStyle.regular15600(whiteColor)),
                        ),
                        Container(
                            margin: EdgeInsets.only(right: width * 0.02),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ADDTabThreeCash(
                                              controller.cashPortfolios,
                                              _portfolio,
                                              centerTitle: 'Add New Cash',
                                            )),
                                  );
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: whiteColor,
                                ))),
                      ],
                    ),
                    const Divider(
                      thickness: 0.2,
                      indent: 15,
                      endIndent: 15,
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    body,
                  ],
                ),
              ],
            );
          },
        )));
  }

  Widget buildSearchResults(width) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "SEARCH RESULTS",
              style: RegularTextStyle.regular15400(whiteColor),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: searchList.length,
          itemBuilder: (context, index) {
            final product = searchList[index];
            log(product.toString());
            return buildSearchDetails(product, index, width);
          },
        ),
      ],
    );
  }

  Widget buildContentWidget(double width) {
    return Consumer<AssetProvider>(builder: (context, value, child) {
      if (value.cashList.isEmpty) {
        return FutureBuilder(
          future: Future.delayed(const Duration(seconds: 4)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return Center(
                child: Text(
                  "No data",
                  style: LargeTextStyle.large18800(whiteColor),
                ),
              );
            }
          },
        );
      } else {
        return ListView.builder(
          key: UniqueKey(),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            _portfolio = value.cashList[index].subCat;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateAssetsScreen(
                      // assetsController
                      //     .assetsPortfolios,
                      // cashController
                      //     .cashPortfolios,
                      index: index,
                      portfolios: value.cashList[index],
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.05,
                        ),
                        // CachedNetworkImage(
                        //     color: transparent,
                        //     imageUrl: 'assets/Dollar.png',
                        //     imageBuilder: (context, imageProvider) =>
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 0),
                        //           child: ClipRRect(
                        //             borderRadius:
                        //                 BorderRadius.circular(20.0),
                        //             child: Container(
                        //               width: MediaQuery.of(context)
                        //                       .size
                        //                       .width /
                        //                   19,
                        //               height: 30,
                        //               decoration: BoxDecoration(
                        //                   color: transparent,
                        //                   image: DecorationImage(
                        //                       image: imageProvider,
                        //                       fit: BoxFit.cover)),
                        //             ),
                        //           ),
                        //         ),
                        //     progressIndicatorBuilder: (context, url,
                        //             downloadProgress) =>
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 14),
                        //           child: ClipRRect(
                        //             borderRadius:
                        //                 BorderRadius.circular(20.0),
                        //             child: Container(
                        //               width: MediaQuery.of(context)
                        //                       .size
                        //                       .width /
                        //                   13,
                        //               height: 30,
                        //               decoration: const BoxDecoration(
                        //                 color: whiteColor,
                        //               ),
                        //               child:
                        //                   const CupertinoActivityIndicator(),
                        //             ),
                        //           ),
                        //         ),
                        //     errorWidget: (context, url, error) => Padding(
                        //           padding: const EdgeInsets.only(
                        //             left: 0,
                        //             right: 0,
                        //             bottom: 0,
                        //             top: 0,
                        //           ),
                        //           child: ClipRRect(
                        //             borderRadius:
                        //                 BorderRadius.circular(20.0),
                        //             child: Container(
                        //               width: MediaQuery.of(context)
                        //                       .size
                        //                       .width /
                        //                   20,
                        //               height: 30,
                        //               decoration: const BoxDecoration(
                        //                   color: transparent,
                        //                   image: DecorationImage(
                        //                       image: AssetImage(
                        //                           'assets/Dollar.png'))),
                        //             ),
                        //           ),
                        //         )),
                        Image.asset(
                          "assets/Dollar.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Text(value.cashList[index].coinName,
                            style: RegularTextStyle.regular15600(iconColor2)),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                              child: Text(
                                  '${value.cashList[index].quantity}  ${value.cashList[index].coinShort}',
                                  style: RegularTextStyle.regular14400(
                                      whiteColor)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                              child: Text(
                                  "\$ ${value.cashList[index].value.toStringAsFixed(2)}",
                                  style: RegularTextStyle.regular14400(
                                      whiteColor)),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.05,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: value.cashList.length,
        );
      }
    });
  }

  Widget buildSearchDetails(SearchData data, index, width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => UpdateAssetsScreen(
            //       index: index,
            //       searchData: data,
            //     ),
            //   ),
            // );
          },
          child: Container(
            height: 80,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 47, 44, 44).withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 1,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   height: 70,
                //   width: 70,
                //   margin: const EdgeInsets.only(right: 15),
                //   child: Image.asset('assets/images/Logo.png'),
                // ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              height: 30,
                              width: 160,
                              child: Text(
                                data.coinName,
                                style:
                                    RegularTextStyle.regular15400(whiteColor),
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              data.value.toString(),
                              style: RegularTextStyle.regular14600(whiteColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
