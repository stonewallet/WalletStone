import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletstone/UI/Trips/provider/new_trip_provider.dart';
import 'package:walletstone/UI/portfolio/portfolio_page.dart';
import 'package:walletstone/UI/Home/setting_page.dart';
import 'package:walletstone/UI/Home/stocks_page.dart';
import '../AddressBook/address_book.dart';
import '../Constants/colors.dart';
import '../Constants/text_styles.dart';
import '../Help And Support/help_and_support.dart';
import '../Model/settings_model.dart';
import '../Other Settings/other_settings.dart';
import '../Privacy/privacy.dart';
import '../Security And Backup/security_and_backup.dart';
import '../Trips/trips.dart';
import '../Wallet/wallet.dart';
import 'mywallet_balance_page.dart';
import 'notification_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({Key? key}) : super(key: key);

  @override
  BottomNavigationPageState createState() => BottomNavigationPageState();
}

class BottomNavigationPageState extends State<BottomNavigationPage> {
  GlobalKey bottomNavigationKey = GlobalKey();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List<Widget> widgetList = [MyWalletBalancePage(), StocksPage(), PortfolioPage(), SettingPage(),];
  List<Widget> widgetList = [
    const MyWalletBalancePage(),
    const TripsPage(),
    const StocksPage(),
    const PortfolioPage(),
    const SettingPage()
  ];
  bool _isClickedDrawer = false;

  List<SettingModel> settings = [
    SettingModel(name: "Connection and sync", image: "assets/Icons/sync.png"),
    SettingModel(name: "Address book", image: "assets/Icons/address-book.png"),
    SettingModel(name: "Privacy and sync", image: "assets/Icons/view.png"),
    SettingModel(name: "Security and backup", image: "assets/Icons/lock.png"),
    SettingModel(
        name: "Display settings", image: "assets/Icons/light-mode.png"),
    SettingModel(name: "Help & Support", image: "assets/Icons/support.png"),
    SettingModel(name: "Privacy settings", image: "assets/Icons/check.png"),
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<NewTripProvider>(context, listen: false).fetchCartItemCount();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.list,
            color: buttonColor,
            size: 40,
          ),
          onTap: () {
            setState(() {
              _isClickedDrawer = true;
            });
          },
        ),
        actions: <Widget>[
          Row(
            children: [
              Consumer<NewTripProvider>(
                builder: (context, provider, child) {
                  final cartItemCount = provider.cartItemCount;
                  if (cartItemCount != null && cartItemCount.message != null) {
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.add_alert,
                            color: buttonColor,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage()),
                            ).then((value) => Provider.of<NewTripProvider>(
                                    context,
                                    listen: false)
                                .fetchCartItemCount());
                          },
                        ),
                        Positioned(
                          right: 5,
                          top: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 9,
                            child: Text(
                              cartItemCount.message.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(
                        Icons.add_alert,
                        color: buttonColor,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationPage()),
                        ).then(
                          (value) => cartItemCount,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background1.png"),
              fit: BoxFit.cover,
            ),
          ),
          width: width,
          height: height,
          child: widgetList.elementAt(_selectedIndex),
        ),
        Visibility(
          visible: _isClickedDrawer,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: width * 0.6,
              height: height * 0.5,
              decoration: const BoxDecoration(
                  color: drawerColor2,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: ListView(
                children: [
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Consumer<NewTripProvider>(
                          builder: (context, value, child) {
                        final firstLetter =
                            value.user.isNotEmpty ? value.user[0] : '';

                        return Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: CircleAvatar(
                              radius: width * 0.04,
                              backgroundColor: gradientColor2,
                              child: Text(
                                firstLetter.toUpperCase(),
                                style:
                                    RegularTextStyle.regular14600(whiteColor),
                              ),
                            ));
                      }),
                      const SizedBox(
                        width: 10,
                      ),
                      Consumer<NewTripProvider>(
                        builder: (context, value, child) {
                          return Expanded(
                            child: Text(
                              value.user,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: LargeTextStyle.large18800(whiteColor),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.close,
                            color: buttonColor,
                            size: width * 0.06,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _isClickedDrawer = false;
                          });
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: width,
                    height: 1,
                    color: drawerColor,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WalletPage()),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Image.asset(
                              "assets/Icons/wallet-filled-money-tool.png",
                              height: 20,
                              width: 20,
                              color: iconColor,
                            ),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Text("Wallets",
                                style:
                                    RegularTextStyle.regular14600(whiteColor)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: width,
                        height: 1,
                        color: drawerColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               const ConnectionAndSyncPage()),
                      //     );
                      //   },
                      //   child: Container(
                      //     margin: const EdgeInsets.only(bottom: 30),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           children: [
                      //             SizedBox(
                      //               width: width * 0.05,
                      //             ),
                      //             Image.asset(
                      //               "assets/Icons/sync.png",
                      //               height: 20,
                      //               width: 20,
                      //               color: iconColor,
                      //             ),
                      //             SizedBox(
                      //               width: width * 0.05,
                      //             ),
                      //             Text(
                      //               "Connection and sync",
                      //               style: RegularTextStyle.regular14600(
                      //                   whiteColor),
                      //             ),
                      //           ],
                      //         ),
                      //         const SizedBox(
                      //           height: 10,
                      //         ),
                      //         Container(
                      //           width: width,
                      //           height: 1,
                      //           color: drawerColor,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddressBookPage()),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Image.asset(
                              "assets/Icons/address-book.png",
                              height: 20,
                              width: 20,
                              color: iconColor,
                            ),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Text(
                              "Address Book",
                              style: RegularTextStyle.regular14600(whiteColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: width,
                        height: 1,
                        color: drawerColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SecurityAndBackupPage()),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Image.asset(
                              "assets/Icons/lock.png",
                              height: 20,
                              width: 20,
                              color: iconColor,
                            ),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Text(
                              "Security and Backup",
                              style: RegularTextStyle.regular14600(whiteColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: width,
                        height: 1,
                        color: drawerColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PrivacyPage()),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Image.asset(
                              "assets/Icons/view.png",
                              height: 20,
                              width: 20,
                              color: iconColor,
                            ),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Text(
                              "Privacy",
                              style: RegularTextStyle.regular14600(whiteColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: width,
                        height: 1,
                        color: drawerColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const OtherSettingsPage()),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Image.asset(
                              "assets/Icons/settings.png",
                              height: 20,
                              width: 20,
                              color: iconColor,
                            ),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Text(
                              "Other Settings",
                              style: RegularTextStyle.regular14600(whiteColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: width,
                        height: 1,
                        color: drawerColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HelpAndSupportPage()),
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Image.asset(
                                  "assets/Icons/support.png",
                                  height: 20,
                                  width: 20,
                                  color: iconColor,
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Text(
                                  "Help & Support",
                                  style:
                                      RegularTextStyle.regular14600(whiteColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: whiteColor,
        unselectedItemColor: iconColor,
        backgroundColor: bottomBackgroundColor,
        type: BottomNavigationBarType.fixed,
        enableFeedback: false,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: AnimatedCrossFade(
              firstCurve: Curves.bounceIn,
              firstChild: Image.asset(
                "assets/Icons/wallet-filled-money-tool.png",
                height: 30,
                width: 30,
                color: greyColor.withOpacity(0.7),
              ),
              secondChild: Image.asset(
                "assets/Icons/wallet-filled-money-tool.png",
                height: 30,
                width: 30,
                color: iconColor,
              ),
              duration: const Duration(milliseconds: 30),
              crossFadeState: _selectedIndex == 0
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedCrossFade(
              firstCurve: Curves.bounceIn,
              firstChild: Image.asset(
                "assets/Icons/plane.png",
                height: 30,
                width: 30,
                color: greyColor.withOpacity(0.7),
              ),
              secondChild: Image.asset(
                "assets/Icons/plane.png",
                height: 30,
                width: 30,
                color: iconColor,
              ),
              duration: const Duration(milliseconds: 30),
              crossFadeState: _selectedIndex == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedCrossFade(
              firstCurve: Curves.bounceIn,
              firstChild: Image.asset(
                "assets/Icons/trend.png",
                height: 30,
                width: 30,
                color: greyColor.withOpacity(0.7),
              ),
              secondChild: Image.asset(
                "assets/Icons/trend.png",
                height: 30,
                width: 30,
                color: iconColor,
              ),
              duration: const Duration(milliseconds: 30),
              crossFadeState: _selectedIndex == 2
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedCrossFade(
              firstCurve: Curves.bounceIn,
              firstChild: Image.asset(
                "assets/Icons/pie-chart-2.png",
                height: 30,
                width: 30,
                color: greyColor.withOpacity(0.7),
              ),
              secondChild: Image.asset(
                "assets/Icons/pie-chart-2.png",
                height: 30,
                width: 30,
                color: iconColor,
              ),
              duration: const Duration(milliseconds: 30),
              crossFadeState: _selectedIndex == 3
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedCrossFade(
              firstCurve: Curves.bounceIn,
              firstChild: Image.asset(
                "assets/Icons/gear.png",
                height: 30,
                width: 30,
                color: greyColor.withOpacity(0.7),
              ),
              secondChild: Image.asset(
                "assets/Icons/gear.png",
                height: 30,
                width: 30,
                color: iconColor,
              ),
              duration: const Duration(milliseconds: 30),
              crossFadeState: _selectedIndex == 4
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
