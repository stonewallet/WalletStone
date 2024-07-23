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
      // log("userid:${userId}");
      // log("usernam:${userName}");
      // log("tripId:${tripId}");
      // log("tripName:${tripName}");
      if (response.statusCode == 200) {
        log("inside response::${response.data}");
        // final responseData = response.data;
        // log(responseData);

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

  Future<bool> deleteSingleTravelEntry({
    bool isProduct = false,
    required String itemName,
    required int tripId,
  }) async {
    final Dio dio = Dio();

    try {
      final response = await dio.post(
        deleteTravelEntry,
        data: {
          "trip_id": tripId,
          "item_type": isProduct ? "product" : "expenses",
          "item_name": itemName,
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
        log("Response data: ${response.data}");
        TravelPostResponse travelPostResponse =
            TravelPostResponse.fromJson(response.data);
        log("Response message: ${travelPostResponse.message}");
        return true;
      } else {
        log("Failed with status code: ${response.statusCode}");
        return false;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse && e.response != null) {
        log("DioError badResponse: ${e.message}");
        log("Status code: ${e.response!.statusCode}");
        log("Status message: ${e.response!.statusMessage}");
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        log("DioError timeout: ${e.message}");
      } else {
        log("DioError: ${e.message}");
      }
      return false;
    } catch (e) {
      log("Exception: $e");
      return false;
    }
  }
}
