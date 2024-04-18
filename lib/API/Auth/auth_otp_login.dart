import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/Responses/travel_post_response.dart';
import 'package:walletstone/UI/Constants/strings.dart';
import 'package:walletstone/UI/Constants/urls.dart';

class APiAuthOTPLogin extends ChangeNotifier {
  final Dio _dio = Dio();
  SharedPreferences? sharedPreferences;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  void getSharePrefs() async {
    sharedPreferences = await _prefs;
  }

  Future<TravelPostResponse> authOTPLogin({
    required int otp,
    required String userName,
    required String password,
  }) async {
    getSharePrefs();
    try {
      if (kDebugMode) {
        print("Login otp Post api hit");
      }
      Response response = await _dio.post(
        "$sendOTPLogin/$otp/",
        data: {
          "username": userName,
          "password": password,
        },
        // options: Options(
        //   headers: {
        //     "Cookie":
        //         "csrftoken=${MySharedPreferences().getCsrfToken(await SharedPreferences.getInstance())}; sessionid=${MySharedPreferences().getSessionId(await SharedPreferences.getInstance())}",
        //     "X-CSRFToken": MySharedPreferences()
        //         .getCsrfToken(await SharedPreferences.getInstance())
        //   },
        //   sendTimeout: const Duration(seconds: 1),
        //   receiveTimeout: const Duration(seconds: 30 * 1000),
        // ),
      );
      if (kDebugMode) {
        print("Auth login data ${response.data}");
      }
      if (response.statusCode == 200) {
        List<String> cookies = response.headers.map['set-cookie']!;
        print(cookies);
        if (cookies.isNotEmpty && cookies.length == 2) {
          String csToken =
              cookies[0].split(';')[0].replaceAll("csrftoken=", "");
          String sessionToken =
              cookies[1].split(';')[0].replaceAll("sessionid=", "");

          // csrfToken = csToken;
          // sessionId = sessionToken;
          MySharedPreferences().setCsrfToken(sharedPreferences!, csToken);
          MySharedPreferences().setSessionId(sharedPreferences!, sessionToken);

          print("csrfToken $csrfToken");
          print("sessionId $sessionId");
          print(MySharedPreferences()
              .getCsrfToken(await SharedPreferences.getInstance()));
        }

        print("cookies $cookies");
      }

      TravelPostResponse travelPostResponse =
          TravelPostResponse.fromJson(json.decode(response.toString()));
      return travelPostResponse;
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
