import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/UI/Constants/urls.dart';

class ApiWalletBalance extends ChangeNotifier {
  final Dio _dio = Dio();
  double value = 0.00;

  Future<dynamic> getWalletBalance({
    required String mnemonic,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        print("Add Post api hit");
      }
      Response response = await _dio.post(
        walletBalance,
        data: {
          "mnemonic": mnemonic,
          "password": password,
        },
        options: Options(
          headers: {
            "Cookie":
                "csrftoken=${MySharedPreferences().getCsrfToken(await SharedPreferences.getInstance())}; sessionid=${MySharedPreferences().getSessionId(await SharedPreferences.getInstance())}",
            "X-CSRFToken": MySharedPreferences()
                .getCsrfToken(await SharedPreferences.getInstance())
          },
          sendTimeout: const Duration(seconds: 3000 * 1000),
          receiveTimeout: const Duration(seconds: 3000 * 1000),
        ),
      );
      if (kDebugMode) {
        print("wallent balance ${response.data}");
      }
      if (response.statusCode == 200) {
        dynamic responseData = response.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        // Assuming the 'balance' field is at the root level of the response data
        double balance = responseData['balance'];

        value = balance;
        log(value.toString());
        notifyListeners();
        return value;
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
