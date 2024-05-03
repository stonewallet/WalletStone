import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/Responses/travel_post_response.dart';
import 'package:walletstone/UI/Constants/urls.dart';

class ApiRestorePassWord extends ChangeNotifier {
  final Dio _dio = Dio();

  Future<TravelPostResponse> changeRestorePassword({
    required String name,
    required String seed,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        print("Add Post api hit");
      }
      Response response = await _dio.post(
        restoreWallet,
        data: {
          "wallet_name": name,
          "mnemonic_seed": seed,
          "password": password,
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
        print("restored seed ${response.data}");
      }
      if (response.statusCode == 200) {
        TravelPostResponse travelPostResponse =
            TravelPostResponse.fromJson(json.decode(response.toString()));

        return travelPostResponse;
      } else {
        throw Exception(
            "Error: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse && e.response != null) {
        // Handle DioError related to bad response
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
