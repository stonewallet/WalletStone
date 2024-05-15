import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/API/contact/post_contact.dart';
import 'package:walletstone/API/settingwallet/get_setting_wallet.dart';
import 'package:walletstone/UI/AddressBook/contact.dart';
import 'package:walletstone/UI/AddressBook/widget/edit_contact.dart';
import 'package:walletstone/UI/Constants/colors.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Model/contact/contact.dart';
import 'package:walletstone/UI/Model/setting/setting_wallet.dart';
import 'package:walletstone/widgets/global.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  late ApiServiceForGetSettingWallets apiServiceForGetSettingWallets;
  late ApiServiceForContact apiServiceForContact;
  @override
  void initState() {
    apiServiceForGetSettingWallets = ApiServiceForGetSettingWallets();
    apiServiceForContact = ApiServiceForContact();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: appBarBackgroundColor,
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
        title:
            Text("Address Book", style: LargeTextStyle.large20700(whiteColor)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddContactPage()),
                );
              },
              icon: const Icon(
                Icons.add,
                color: whiteColor,
                size: 25,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "My Wallets",
              style: LargeTextStyle.large28600(whiteColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SizedBox(
              child: FutureBuilder<List<GetWallet>>(
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

                    return ListView.builder(
                      key: UniqueKey(),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.transparent,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  SizedBox(
                                    width: 40,
                                    height: 35,
                                    child: Image.asset(
                                      'assets/Icons/wallet-filled-money-tool.png',
                                      color: newGradient1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(wallets[index].mnemonic!,
                                      style: LargeTextStyle.large18800(
                                          whiteColor)),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.end,
                              //       children: [
                              //         IconButton(
                              //           onPressed: () {},
                              //           icon: const Icon(
                              //             Icons.edit,
                              //             size: 20,
                              //             color: whiteColor,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     SizedBox(
                              //       width: width * 0.05,
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                        );
                      },
                      itemCount: wallets.length,
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contacts", style: LargeTextStyle.large28600(whiteColor)),
                const SizedBox(
                  height: 10,
                ),
                Consumer<ApiServiceForContact>(
                  builder: (context, value, child) {
                    return FutureBuilder(
                      future: apiServiceForContact.getContact(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              "No Contact",
                              style: LargeTextStyle.large18800(whiteColor),
                            ),
                          );
                        } else if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                              "No Contact",
                              style: LargeTextStyle.large18800(whiteColor),
                            ),
                          );
                        } else {
                          final List<Contacts> contact = snapshot.data!;

                          return ListView.builder(
                            itemCount: contact.length,
                            key: UniqueKey(),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        SizedBox(
                                            width: 40,
                                            height: 30,
                                            child: SvgPicture.asset(
                                                "assets/Icons/person.svg")),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(contact[index].contactName!,
                                            style: LargeTextStyle.large20700(
                                                whiteColor)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditContactPage(
                                                          contacts:
                                                              contact[index],
                                                        )));
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 30,
                                            color: whiteColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.001,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _showDeleteConfirmationDialog(
                                                context, contact[index].id!);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 30,
                                            color: redColor,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int iD) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete',
            style: RegularTextStyle.regular14600(blackColor),
          ),
          content: Text(
            'Are you sure you want to Delete?',
            style: RegularTextStyle.regular14600(blackColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: RegularTextStyle.regular14600(blackColor),
              ),
            ),
            Consumer<ApiServiceForContact>(
              builder: (context, value, child) => TextButton(
                onPressed: () async {
                  var response = await value.deleteContact(iD);
                  if (response != false) {
                    value.getContact();
                  alert('Contact deleted successfully');
                    // Get.snackbar(
                    //   "Contact deleted successfully",
                    //   '',
                    //   backgroundColor: newGradient6,
                    //   colorText: whiteColor,
                    //   padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                    //   duration: const Duration(milliseconds: 4000),
                    //   snackPosition: SnackPosition.BOTTOM,
                    // );
                  } else {
                    value.getContact();
                    alert('Contact deleted successfully');
                    // Get.snackbar(
                    //   "Contact deleted successfully",
                    //   '',
                    //   backgroundColor: newGradient6,
                    //   colorText: whiteColor,
                    //   padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                    //   duration: const Duration(milliseconds: 4000),
                    //   snackPosition: SnackPosition.BOTTOM,
                    // );
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: RegularTextStyle.regular14600(dotColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
