import 'package:flutter/material.dart';
import 'package:walletstone/UI/Constants/text_styles.dart';
import 'package:walletstone/UI/Wallet/restore_from_seed.dart';

import '../Constants/colors.dart';

class RestoreWalletPage extends StatefulWidget {
  const RestoreWalletPage({super.key});

  @override
  State<RestoreWalletPage> createState() => _RestoreWalletPageState();
}

class _RestoreWalletPageState extends State<RestoreWalletPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
        title: Text("Restore Wallet",
            style: LargeTextStyle.large20500(whiteColor)),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RestoreFromSeedPage()),
              );
            },
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: decorationColor),
                child: Row(
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) => const RadialGradient(
                        center: Alignment.center,
                        radius: 0.5,
                        // stops: [0.5, 1],
                        colors: [
                          gradientColor3,
                          gradientColor4,
                        ],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.access_time,
                        size: 40,
                      ),
                    ),
                    // Icon(Icons.wallet, color: Colors.deepPurple,size: 40,),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Restore from seed/keys",
                            style: LargeTextStyle.large20600(whiteColor),
                          ),
                          Text(
                            "Get back your wallet from seed/ keys that you've saved to secure place",
                            style: RegularTextStyle.regular14400(whiteColor),
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
