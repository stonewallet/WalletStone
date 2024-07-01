import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:walletstone/API/portfolio_api/api_services.dart';
import 'package:walletstone/API/portfolio_api/search_api.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Model/portfolio/portfolio_model.dart';
import 'package:walletstone/UI/Model/portfolio/search_model.dart';
import 'package:walletstone/UI/portfolio/controller/portfolip_controller.dart';
import 'package:walletstone/UI/portfolio/widgets/add_new_assets.dart';
import 'package:walletstone/UI/portfolio/widgets/updateanddelete_assets.dart';

class TabBarScreenOne extends StatefulWidget {
  const TabBarScreenOne({super.key});

  @override
  State<TabBarScreenOne> createState() => _TabBarScreenOneState();
}

class _TabBarScreenOneState extends State<TabBarScreenOne> {
  late TextEditingController searchController = TextEditingController();

  late ApiService apiService;
  int _portfolio = 0;
  List<SearchData> searchList = [];
  bool isSearchidle = true;

  final controller = Get.put(PortfolioController());
  // final cashController = Get.put(PortfolioController3());
  late double width;
  late double height;

  @override
  void initState() {
    setState(() {});
    apiService = ApiService();
    super.initState();
    _getSearch();
    searchController.addListener(onSearchTextControlled);
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
        body: Builder(builder: (context) {
          return SingleChildScrollView(
            child: GetBuilder<PortfolioController>(
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
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: width * 0.06),
                          child: Text('Crypto',
                              style: RegularTextStyle.regular15600(whiteColor)),
                        ),
                        Container(
                            margin: EdgeInsets.only(right: width * 0.02),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddAssetsDetail(
                                              controller.portfolios,
                                              _portfolio,
                                              centerTitle: 'Add New Crypto',
                                            )),
                                  );
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: whiteColor,
                                ))),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      indent: 10,
                      color: Colors.black.withOpacity(0.2),
                      endIndent: 10,
                    ),
                    body
                  ],
                );
              },
            ),
          );
        }));
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

  FutureBuilder<List<Portfolio>> buildContentWidget(double width) {
    return FutureBuilder<List<Portfolio>>(
        future: apiService.getData(),
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
            final List<Portfolio> portfolios = snapshot.data!;

            return ListView.builder(
              key: UniqueKey(),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                _portfolio = portfolios[index].subCat;
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
                            portfolios: portfolios[index]),
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
                            CachedNetworkImage(
                                color: transparent,
                                imageUrl:
                                    'https://www.${portfolios[index].imageUrl}',
                                imageBuilder: (context, imageProvider) =>
                                    ClipOval(
                                      // borderRadius: BorderRadius.circular(20.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                19,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: transparent,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                progressIndicatorBuilder: (context, url,
                                        downloadProgress) =>
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                19,
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: whiteColor,
                                        ),
                                        child:
                                            const CupertinoActivityIndicator(),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        top: 0,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                              color: transparent,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/Dollar.png'))),
                                          child:
                                              Image.asset('assets/Dollar.png'),
                                        ),
                                      ),
                                    )),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Text(portfolios[index].coinName,
                                style:
                                    RegularTextStyle.regular15600(iconColor2)),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                  child: Text(
                                      '${portfolios[index].quantity}  ${portfolios[index].coinShort}',
                                      style: RegularTextStyle.regular14400(
                                          whiteColor)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                  child: Text(
                                      "\$ ${portfolios[index].value.toStringAsFixed(2)}",
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
              itemCount: portfolios.length,
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
