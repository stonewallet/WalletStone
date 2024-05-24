import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Security%20And%20Backup/changeuser_pass.dart';
import 'package:walletstone/UI/Security%20And%20Backup/provider/twofactor_sw.dart';
import 'package:walletstone/UI/Security%20And%20Backup/select_wallet.dart';
import 'package:walletstone/UI/Security%20And%20Backup/setup2FA.dart';

import '../Constants/colors.dart';

bool isBiometricEnabled = false;

String selectedOption = '10 minutes';

class SecurityAndBackupPage extends StatefulWidget {
  const SecurityAndBackupPage({super.key});

  @override
  State<SecurityAndBackupPage> createState() => _SecurityAndBackupPageState();
}

class _SecurityAndBackupPageState extends State<SecurityAndBackupPage> {
  bool button = false;
  final List<String> dropdownOptions = [
    '5 minutes',
    '10 minutes',
    '15 minutes'
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
  }

  Future<void> _loadSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOption = prefs.getString('selectedOption') ?? '10 minutes';
    setState(() {
      selectedOption = savedOption;
    });
  }

  Future<void> _saveSelectedOption(String option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedOption', option);
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
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
        ),
        title: Text("Security and backup",
            style: LargeTextStyle.large20700(whiteColor)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.03,
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectWalletPage()),
                  );
                },
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Show seed/keys ",
                                style:
                                    RegularTextStyle.regular15600(whiteColor)),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: iconColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: width,
                      height: 1,
                      color: drawerColor,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BackupPage()),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Change User Password",
                              style: RegularTextStyle.regular15600(whiteColor)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: iconColor,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: width,
                      height: 1,
                      color: drawerColor,
                    )
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // // InkWell(
              // //   onTap: () {
              // //     screenLockCreate(
              // //       context: context,
              // //       title: const Text('Enter your PIN'),
              // //       confirmTitle: const Text('Enter your pin again'),
              // //       onConfirmed: (value) => Navigator.of(context).pop(),
              // //       config: const ScreenLockConfig(
              // //         backgroundColor: appBarBackgroundColor,
              // //       ),
              // //       secretsConfig: const SecretsConfig(
              // //         spacing: 15, // or spacingRatio
              // //         padding: EdgeInsets.all(40),
              // //         secretConfig: SecretConfig(
              // //             // borderColor: Colors.amber,
              // //             borderSize: 2.0,
              // //             disabledColor: Colors.black,
              // //             enabledColor: whiteColor
              // //             // enabledColor: Colors.amber,

              // //             ),
              // //       ),
              // //       keyPadConfig: const KeyPadConfig(
              // //         buttonConfig: KeyPadButtonConfig(
              // //             backgroundColor: Colors.transparent,
              // //             fontSize: 20,
              // //             foregroundColor: whiteColor),
              // //         displayStrings: [
              // //           '0',
              // //           '1',
              // //           '2',
              // //           '3',
              // //           '4',
              // //           '5',
              // //           '6',
              // //           '7',
              // //           '8',
              // //           '9'
              // //         ],
              // //       ),
              // //       cancelButton: const Icon(Icons.close),
              // //       // deleteButton: const Icon(Icons.delete),
              // //     );
              // //     // Navigator.push(
              // //     //   context,
              // //     //   MaterialPageRoute(builder: (context)
              // //     //   =>  const ChangePinPage()),
              // //     // );
              // //   },
              // //   child: Column(
              // //     children: [
              // //       Container(
              // //         height: 40,
              // //         padding: const EdgeInsets.symmetric(horizontal: 20),
              // //         child: Row(
              // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // //           children: [
              // //             Text("Change Wallet PIN",
              // //                 style: RegularTextStyle.regular15600(whiteColor)),
              // //             const Icon(
              // //               Icons.arrow_forward_ios,
              // //               size: 20,
              // //               color: iconColor,
              // //             )
              // //           ],
              // //         ),
              // //       ),
              //       const SizedBox(
              //         height: 10,
              //       ),
              //       Container(
              //         width: width,
              //         height: 1,
              //         color: drawerColor,
              //       )
              //     ],
              //   ),
              // ),
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Allow biometrical authentication",
                            style: RegularTextStyle.regular15600(whiteColor)),
                        Switch.adaptive(
                          inactiveThumbColor: redColor,
                          activeColor:
                              isBiometricEnabled ? stockGreenColor : redColor,
                          value: isBiometricEnabled,
                          onChanged: (value) {
                            setState(() => isBiometricEnabled = value);
                            saveBiometricState(value);
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: width,
                    height: 1,
                    color: drawerColor,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Require PIN after",
                            style: RegularTextStyle.regular15600(whiteColor),
                          ),
                          DropdownButton<String>(
                            dropdownColor: drawerColor,
                            value: selectedOption,
                            items: dropdownOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style:
                                      RegularTextStyle.regular14600(whiteColor),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedOption = newValue;
                                  _saveSelectedOption(newValue);
                                });
                                if (kDebugMode) {
                                  print("Selected option: $selectedOption");
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: width,
                      height: 1,
                      color: drawerColor,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<TwoFactorProvider>(
                builder: (context, value, child) => InkWell(
                  onTap: () {
                    value.checkAuthStatus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Setup2FA()),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Setup  2FA",
                                style:
                                    RegularTextStyle.regular15600(whiteColor)),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: iconColor,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width,
                        height: 1,
                        color: drawerColor,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> saveBiometricState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('biometricEnabled', value);
  }
}
