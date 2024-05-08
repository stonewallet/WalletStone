import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walletstone/UI/Model/coin_model.dart';

void alert(String alert) {
  Fluttertoast.showToast(
    msg: alert,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.indigo,
  );
}

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
      amount: "1 Coins",
      usdAmount: "\$1240"),
  CoinModel(
      name: "XRP",
      type: "Ripple",
      icon: "assets/Icons/ripple.png",
      amount: "1 Coins",
      usdAmount: "\$1240"),
  CoinModel(
      name: "XRP",
      type: "Ripple",
      icon: "assets/Icons/ripple.png",
      amount: "1 Coins",
      usdAmount: "\$1240"),
  CoinModel(
      name: "XRP",
      type: "Ripple",
      icon: "assets/Icons/ripple.png",
      amount: "1 Coins",
      usdAmount: "\$1240"),
  CoinModel(
      name: "XRP",
      type: "Ripple",
      icon: "assets/Icons/ripple.png",
      amount: "1 Coins",
      usdAmount: "\$1240"),
  CoinModel(
      name: "XRP",
      type: "Ripple",
      icon: "assets/Icons/ripple.png",
      amount: "1 Coins",
      usdAmount: "\$1240"),
  CoinModel(
      name: "XRP",
      type: "Ripple",
      icon: "assets/Icons/ripple.png",
      amount: "1 Coins",
      usdAmount: "\$1240"),
  CoinModel(
      name: "XRP",
      type: "Ripple",
      icon: "assets/Icons/ripple.png",
      amount: "1 Coins",
      usdAmount: "\$1240"),
  CoinModel(
      name: "XRP",
      type: "Ripple",
      icon: "assets/Icons/ripple.png",
      amount: "1 Coins",
      usdAmount: "\$1240"),
  CoinModel(
      name: "XRP",
      type: "Ripple",
      icon: "assets/Icons/ripple.png",
      amount: "1 Coins",
      usdAmount: "\$1240"),
];
