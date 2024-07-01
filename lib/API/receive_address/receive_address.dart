import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/UI/Constants/urls.dart';
import 'package:http/http.dart' as http;

class ApiPublicAddress extends ChangeNotifier {
  // final Dio _dio = Dio();
  String value = 'm';

  Future<dynamic> getPublicAddress({
    required String mnemonic,
  }) async {
    if (kDebugMode) {
      log("Add Post api hit");
    }
    final response = await http.post(
      Uri.parse(publicAddress),
      body: {
        "mnemonic": mnemonic,
      },

      headers: {
        "Cookie":
            "csrftoken=${MySharedPreferences().getCsrfToken(await SharedPreferences.getInstance())}; sessionid=${MySharedPreferences().getSessionId(await SharedPreferences.getInstance())}",
        "X-CSRFToken": MySharedPreferences()
            .getCsrfToken(await SharedPreferences.getInstance())
      },
      // sendTimeout: const Duration(seconds: 3000 * 1000),
      // receiveTimeout: const Duration(seconds: 3000 * 1000),
    );

    if (response.statusCode == 200) {
      dynamic responseData = response.body;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      String balance = responseData['address'];

      value = balance;
      log(value.toString());
      notifyListeners();
      return value;
    } else if (response.statusCode == 400) {
      dynamic responseData = response.body;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      String balance = responseData['message'];

      value = balance;
      log(value.toString());
      notifyListeners();
      return value;
    } else {
      log(response.statusCode.toString());
    }
  }
}
