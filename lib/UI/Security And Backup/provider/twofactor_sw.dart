import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/UI/Constants/urls.dart';

class TwoFactorProvider extends ChangeNotifier {
  late bool _isEnabled;

  bool get isEnabled => _isEnabled;

  void toggleSwitch(bool value) {
    _isEnabled = value;
    notifyListeners();
  }

  final Dio _dio = Dio();
  Future<dynamic> checkAuthStatus() async {
    try {
      if (kDebugMode) {
        log("Add Post api hit");
      }
      Response response = await _dio.get(
        checkAuthStatusValue,
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
        log("addUser ${response.data}");
      }
      if (response.statusCode == 200) {
        // CheckAuthStatus travelPostResponse =
        //     CheckAuthStatus.fromJson(json.decode(response.toString()));
        _isEnabled = response.data['has_2FAEnabled'];
        notifyListeners();
        // return travelPostResponse;
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
