import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/GetNotification/get_notification.dart';
import 'package:walletstone/API/api_provider.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Home/provider/notification_provider.dart';
import 'package:walletstone/UI/Model/notification_model.dart';
import 'package:walletstone/UI/Trips/provider/trip_provider.dart';
import 'package:walletstone/widgets/global.dart';

import '../Constants/colors.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late ApiServiceForNotification apiServiceForNotification;
  // late Future<List<NotificationModel>> notificationsFuture;

  @override
  void initState() {
    apiServiceForNotification = ApiServiceForNotification();
    // notificationsFuture = apiServiceForNotification.getDataForNotification();
    Provider.of<NotificationProvider>(context, listen: false).getNotification();
    super.initState();
  }

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xff182C4B),
      appBar: AppBar(
        leading: GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Icon(
              Icons.arrow_back_ios,
              color: textColor,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xff182C4B),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Notifications",
                  style: LargeTextStyle.large20700(whiteColor)),
              const SizedBox(width: 5),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  border: Border.all(color: dotColor),
                  color: dotColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              )
            ],
          ),
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, value, child) {
          if (value.notifications.isEmpty) {
            return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 4)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
              itemCount: value.notifications.length,
              itemBuilder: (BuildContext context, int index) {
                String message = value.notifications[index].message;
                NotificationModel notification = value.notifications[index];
                int maxLength = message.length ~/ 2;
                String truncatedMessage = '${message.substring(0, maxLength)}.';

                // Access metaData list from NotificationModel
                List<MetaDatum> metaData = notification.metaData;

                return Card(
                  elevation: 2,
                  color: transparent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 3),
                    height: notificationProvider.expandedIndices.contains(index)
                        ? null
                        : height / 12.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var response = await apiServiceForNotification
                                .readMessage(value.notifications[index].id);
                            if (response.message != null) {}
                            notificationProvider.toggleExpansion(index);
                            // setState(() {
                            //   // Toggle visibility for the tapped notification
                            //   if (expandedIndices.contains(index)) {
                            //     expandedIndices.remove(index);
                            //   } else {
                            //     expandedIndices
                            //         .clear(); // Collapse other notifications
                            //     expandedIndices.add(index);
                            //   }
                            // });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: width * 0.03.w),
                                  Icon(
                                    Entypo.message,
                                    color:
                                        value.notifications[index].readMessage
                                            ? whiteColor.withOpacity(0.6)
                                            : Colors.white,
                                  ),
                                  SizedBox(width: 10.w),
                                  SizedBox(
                                    width: 150.w,
                                    child: Text(
                                      truncatedMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: RegularTextStyle.regular15600(
                                        value.notifications[index].readMessage
                                            ? whiteColor.withOpacity(0.6)
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 100.w),
                                  SizedBox(
                                    height: 25,
                                    child: IconButton(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 10, 5),
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Delete',
                                                style: RegularTextStyle
                                                    .regular14600(blackColor),
                                              ),
                                              content: Text(
                                                'Are you sure you want to Delete?',
                                                style: RegularTextStyle
                                                    .regular14600(blackColor),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: RegularTextStyle
                                                        .regular14600(
                                                            blackColor),
                                                  ),
                                                ),
                                                Consumer<NotificationProvider>(
                                                  builder:
                                                      (context, value, child) =>
                                                          TextButton(
                                                    onPressed: () async {
                                                      var response =
                                                          await apiServiceForNotification
                                                              .deleteMessage(value
                                                                  .notifications[
                                                                      index]
                                                                  .id);
                                                      setState(() {});
                                                      value.getNotification();
                                                      if (response.message !=
                                                          null) {
                                                        Get.back();
                                                        alert(
                                                            response.message!);
                                                        // Get.snackbar(
                                                        //   " Deleted successfully",
                                                        //   '',
                                                        //   backgroundColor:
                                                        //       newGradient6,
                                                        //   colorText: whiteColor,
                                                        //   padding:
                                                        //       const EdgeInsets
                                                        //           .fromLTRB(
                                                        //           20, 5, 0, 0),
                                                        //   duration:
                                                        //       const Duration(
                                                        //           milliseconds:
                                                        //               4000),
                                                        //   snackPosition:
                                                        //       SnackPosition
                                                        //           .BOTTOM,
                                                        // );
                                                      } else {
                                                        // Get.snackbar(
                                                        //   "Something gone wrong",
                                                        //   '',
                                                        //   backgroundColor:
                                                        //       newGradient6,
                                                        //   colorText: whiteColor,
                                                        //   padding:
                                                        //       const EdgeInsets
                                                        //           .fromLTRB(
                                                        //           20, 5, 0, 0),
                                                        //   duration:
                                                        //       const Duration(
                                                        //           milliseconds:
                                                        //               4000),
                                                        //   snackPosition:
                                                        //       SnackPosition
                                                        //           .BOTTOM,
                                                        // );
                                                        alert(
                                                            'Something gone wrong');
                                                      }
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: RegularTextStyle
                                                          .regular14600(
                                                              dotColor),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: redColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (notificationProvider.expandedIndices
                            .contains(index))
                          readNotification(width, value.notifications[index],
                              metaData[0], notificationProvider, index),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget readNotification(double width, NotificationModel notifications,
      MetaDatum metaDatum, NotificationProvider notificationProvider, index) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notifications.message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<NotificationProvider>(
                builder: (context, value, child) => GestureDetector(
                  child: CircleAvatar(
                    child: Container(
                        width: width * 0.30,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.green,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Entypo.check)),
                  ),
                  onTap: () async {
                    var tripprovider =
                        Provider.of<TripProvider>(context, listen: false);
                    log(metaDatum.tripId);
                    var response = await ApiProvider()
                        .processAddUser(int.parse(metaDatum.tripId));
                    value.getNotification();
                    tripprovider.fetch();
                    notificationProvider.toggleExpansion(index);
                    if (response.message != null) {
                      alert(response.message!);
                    } else {
                      Get.snackbar(
                        "Something gone wrong",
                        '',
                        backgroundColor: newGradient6,
                        colorText: whiteColor,
                        padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                        duration: const Duration(milliseconds: 4000),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                width: width / 8,
              ),
              GestureDetector(
                child: CircleAvatar(
                  child: Container(
                      width: width * 0.30,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        color: redColor,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.close)),
                ),
                onTap: () {
                  notificationProvider.toggleExpansion(index);
                },
              ),
              const SizedBox(
                height: 10,
              )
            ],
          )
        ],
      ),
    );
  }
}
