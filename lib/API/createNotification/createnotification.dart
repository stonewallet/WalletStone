import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/Responses/travel_post_response.dart';
import 'package:walletstone/UI/Constants/urls.dart';

class ApiServiceForCreateNotification extends ChangeNotifier {
  Future<TravelPostResponse> createNotofication(
      {required String userId,
      required String userName,
      required String tripName,
      required String tripId}) async {
    final Dio dio = Dio();

    try {
      final response = await dio.post(
        createNotification,
        data: {
          "user_id": userId,
          "username": userName,
          "trip_name": tripName,
          "trip_id": tripId,
        },
        options: Options(
          headers: {
            "Cookie":
                "csrftoken=${MySharedPreferences().getCsrfToken(await SharedPreferences.getInstance())}; sessionid=${MySharedPreferences().getSessionId(await SharedPreferences.getInstance())}",
            "X-CSRFToken": MySharedPreferences().getCsrfToken(
              await SharedPreferences.getInstance(),
            ),
          },
          sendTimeout: const Duration(seconds: 1),
          receiveTimeout: const Duration(seconds: 30 * 1000),
        ),
      );
      if (response.statusCode == 200) {
        final responseData = response.data;
        log(responseData);

        TravelPostResponse travelPostResponse =
            TravelPostResponse.fromJson(json.decode(response.toString()));
        log(travelPostResponse.message.toString());
        return travelPostResponse;
      } else {
        throw Exception('Failed to load PDF data');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse && e.response != null) {
        // Handle DioError related to bad response
        log(e.message.toString());
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
