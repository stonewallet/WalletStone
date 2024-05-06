import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/Responses/travel_post_response.dart';
import 'package:walletstone/UI/Constants/urls.dart';

class ApiForSendWallet extends ChangeNotifier {
  final Dio _dio = Dio();
  Future<dynamic> sendWalletPost(
      String name, String password, String address, double amount1) async {
    try {
      if (kDebugMode) {
        print("send wallet api hit");
      }
      Response response = await _dio.post(
        sendWallet,
        data: {
          "mnemonic": name,
          "password": password,
          "recipient_address": address,
          "amount": amount1,
        },
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
        print("addUser ${response.data}");
      }
      if (response.statusCode == 200) {
        TravelPostResponse travelPostResponse =
            TravelPostResponse.fromJson(json.decode(response.toString()));
        return travelPostResponse;
      } else if (response.statusCode == 404) {
        TravelPostResponse travelPostResponse =
            TravelPostResponse.fromJson(json.decode(response.toString()));
        return travelPostResponse;
      } else {
        print(response.statusCode);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse && e.response != null) {
        if (e.response!.statusCode == 404) {
          TravelPostResponse travelPostResponse =
              TravelPostResponse.fromJson(json.decode(e.response.toString()));
          return travelPostResponse;
        }
        throw Exception(
            "Error: ${e.response!.statusCode} - ${e.response!.statusMessage}");
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // Handle DioError related to timeout
        throw Exception("Error: Timeout occurred while fetching data");
      } else {
        // Handle other DioErrors
        throw Exception('Error: $e');
      }
    } catch (e) {
      // Handle generic exceptions
      throw Exception('Error: $e');
    }
  }
}
