import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Trips/provider/trip_provider.dart';
import 'package:walletstone/widgets/global.dart';
import '../../API/api_provider.dart';
import '../Constants/colors.dart';
import 'create_new_trip.dart';
import 'edit_trip.dart';
import 'new_trip.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  // List<TravelList> travelList = <TravelList>[];
  bool isSwitch = true;

  @override
  void initState() {
    // ApiProvider().processLogin();
    // fetch();
    super.initState();
    Provider.of<TripProvider>(context, listen: false).fetch();
  }

  // fetch() async {
  //   setState(() {});
  //   travelList.clear();
  //   travelList = await ApiProvider().processTravel();
  //   setState(() {});
  //   if (kDebugMode) {
  //     log("travelList $travelList");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<TripProvider>(builder: (context, value, child) {
          return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
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
                              Text(
                                "Trips",
                                style: LargeTextStyle.large20700(whiteColor),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: width * 0.15,
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (value.travelList.isEmpty)
                                    FutureBuilder(
                                      future: Future.delayed(
                                          const Duration(seconds: 3)),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          return Center(
                                            child: Text(
                                              "No trip for current User",
                                              style:
                                                  RegularTextStyle.regular16700(
                                                      whiteColor),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  else
                                    SizedBox(
                                      height: 480,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemCount: value.travelList.length,
                                          itemBuilder: (c, i) {
                                            // bool isEndTrip =
                                            //     value.travelList[i].endTrip;
                                            // bool moreThanOneUser = value
                                            //         .travelList[i]
                                            //         .user
                                            //         .length >
                                            //     1;

                                            // Color buttonColor = isEndTrip
                                            //     ? redColor
                                            //     : whiteColor;
                                            // if (moreThanOneUser) {
                                            //   buttonColor = isEndTrip
                                            //       ? stockGreenColor
                                            //       : redColor;
                                            // }
                                            Color changingButtonColor =
                                                Provider.of<TripProvider>(
                                                        context)
                                                    .getButtonColor(i);

                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 55,
                                                      width: width * 0.70,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  buttonColor3,
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20))),
                                                              surfaceTintColor:
                                                                  blackColor,
                                                              shadowColor:
                                                                  whiteColor,
                                                              elevation: 1),
                                                          onPressed: () {
                                                            int id = value
                                                                .travelList[i]
                                                                .id;
                                                            if (kDebugMode) {
                                                              log(id.toString());
                                                            }
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      NewTripPage(
                                                                          id)),
                                                            );
                                                          },
                                                          child: Text(
                                                              value
                                                                  .travelList[i]
                                                                  .tripName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: LargeTextStyle
                                                                  .large20700(
                                                                      changingButtonColor))),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            EditTripPage(
                                                                              value.travelList[i].id,
                                                                              value.travelList[i].tripName,
                                                                              value.travelList[i].product,
                                                                              value.travelList[i].expenses,
                                                                              value.travelList[i].createdAt.toString(),
                                                                              value.travelList[i].user,
                                                                              value.travelList[i].userOrder,
                                                                            )),
                                                              );
                                                            },
                                                            child: const Icon(
                                                              Icons.edit,
                                                              color: whiteColor,
                                                              size: 25,
                                                            )),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        InkWell(
                                                            onTap: () async {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      'Delete',
                                                                      style: RegularTextStyle
                                                                          .regular14600(
                                                                              blackColor),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      'Are you sure you want to Delete?',
                                                                      style: RegularTextStyle
                                                                          .regular14600(
                                                                              blackColor),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style:
                                                                              RegularTextStyle.regular14600(blackColor),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          var response = await ApiProvider().processTravelDelete(value
                                                                              .travelList[i]
                                                                              .id);
                                                                          // fetch();
                                                                          value
                                                                              .travelList
                                                                              .removeAt(i);
                                                                          value
                                                                              .fetch();
                                                                          if (response.message !=
                                                                              null) {
                                                                            Get.back();
                                                                            alert(response.message!);
                                                                            // var snackBar = SnackBar(
                                                                            //     content: Text(
                                                                            //         "Assets created successfully"));
                                                                            // ScaffoldMessenger.of(context)
                                                                            //     .showSnackBar(snackBar);
                                                                          } else {
                                                                            alert("Something gone wrong");
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Delete',
                                                                          style:
                                                                              RegularTextStyle.regular14600(dotColor),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                              // var response = await ApiProvider().processTravelDelete(travelList[i].id);
                                                              // if(response.message != null){
                                                              //   var snackBar = SnackBar(content: Text(response.message!));
                                                              //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              // }else{
                                                              //   var snackBar = SnackBar(content: Text("Something went wrong"));
                                                              //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              // }
                                                            },
                                                            child: const Icon(
                                                              Icons.delete,
                                                              size: 25,
                                                              color: redColor,
                                                            ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 55,
                                          width: width * 0.4,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 176, 231, 235),
                                                  surfaceTintColor: blackColor,
                                                  shadowColor: whiteColor,
                                                  elevation: 2),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const CreateNewTripPage()),
                                                );
                                              },
                                              child: Text("CREATE",
                                                  textAlign: TextAlign.center,
                                                  style: RegularTextStyle
                                                      .regular16bold(
                                                          buttonColor3))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ]);
        }));
  }
}
