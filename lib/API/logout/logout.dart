import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/Responses/travel_post_response.dart';
import 'package:walletstone/UI/Constants/urls.dart';

class ApiServiceForLogOut {
  final Dio _dio = Dio();

  Future<TravelPostResponse> logOut() async {
    try {
      if (kDebugMode) {
        log("logout api hit");
      }
      Response response = await _dio.post(
        logOutPost,
        options: Options(
          headers: {
            "Cookie":
                "csrftoken=${MySharedPreferences().getCsrfToken(await SharedPreferences.getInstance())}; sessionid=${MySharedPreferences().getSessionId(await SharedPreferences.getInstance())}",
            "X-CSRFToken": MySharedPreferences()
                .getCsrfToken(await SharedPreferences.getInstance())
          },
          sendTimeout: const Duration(seconds: 1),
          receiveTimeout: const Duration(seconds: 30 * 1000),
        ),
      );
      if (kDebugMode) {
        log("logout ${response.data}");
      }

      TravelPostResponse travelPostResponse =
          TravelPostResponse.fromJson(json.decode(response.toString()));
      return travelPostResponse;
    } catch (error) {
      if (kDebugMode) {
        log("Error logout list $error");
      }
      rethrow;
    }
  }
}
