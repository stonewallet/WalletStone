import 'dart:convert';
import 'dart:developer';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/Responses/travel_post_response.dart';
import 'package:walletstone/UI/Constants/urls.dart';

class ApiServiceForADDAssets {
  final Dio _dio = Dio();

  Future<TravelPostResponse> createPortfolio1() async {
    try {
      if (kDebugMode) {
        log("Create portfolio api hit");
      }
      final response = await _dio.post(
        portfolio,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            "Cookie":
                "csrftoken=${MySharedPreferences().getCsrfToken(await SharedPreferences.getInstance())}; sessionid=${MySharedPreferences().getSessionId(await SharedPreferences.getInstance())}",
            "X-CSRFToken": MySharedPreferences()
                .getCsrfToken(await SharedPreferences.getInstance())
          },
          sendTimeout: const Duration(seconds: 1),
          receiveTimeout: const Duration(seconds: 30 * 1000),
        ),
        data: jsonEncode([]),
      );

      if (kDebugMode) {
        log("addUser ${response.data}");
      }
      TravelPostResponse travelPostResponse =
          TravelPostResponse.fromJson(json.decode(response.toString()));
      return travelPostResponse;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse && e.response != null) {
        throw Exception(
            "Error: ${e.response!.statusCode} - ${e.response!.statusMessage}");
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Error: Timeout occurred while fetching data");
      } else {
        throw Exception('Error: $e');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<TravelPostResponse> addAsset(
      String name, double quantity, int subcat) async {
    //   try {
    //     final response = await _dio.post(
    //       'YOUR_API_ENDPOINT_HERE',
    //       data: {
    //         'coin_name': coinName,
    //         'quantity': quantity,
    //       },
    //     );

    //     // Handle response
    //     if (response.statusCode == 200) {
    //       // Request successful, handle the response data
    //       log('Asset added successfully');
    //     } else {
    //       // Request failed, handle error
    //       log('Failed to add asset. Status code: ${response.statusCode}');
    //     }
    //   } catch (e) {
    //     // Handle error
    //     log('Error adding asset: $e');
    //     rethrow; // Rethrow the error to propagate it
    //   }
    // }
    try {
      if (kDebugMode) {
        log("Add Post api hit");
      }
      Response response = await _dio.post(
        createPortfolio,
        data: {"coin_name": name, "quantity": quantity, "sub_cat": subcat},
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
      TravelPostResponse travelPostResponse =
          TravelPostResponse.fromJson(json.decode(response.toString()));
      return travelPostResponse;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse && e.response != null) {
        if (e.response!.statusCode == 400) {
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

  Future<TravelPostResponse> update(
      String name, double quantity, int subcat) async {
    try {
      if (kDebugMode) {
        log("Add Post api hit");
      }
      Response response = await _dio.put(
        updatePortfolio,
        data: {"coin_name": name, "quantity": quantity, "sub_cat": subcat},
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

  Future<TravelPostResponse> delete(
      String name, double quantity, int subcat) async {
    try {
      if (kDebugMode) {
        log("Add Post api hit");
      }
      Response response = await _dio.delete(
        deletePortfolio,
        data: {"coin_name": name, "quantity": quantity, "sub_cat": subcat},
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
