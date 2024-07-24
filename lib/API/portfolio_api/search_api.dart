import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/UI/Constants/urls.dart';
import 'package:walletstone/UI/Model/portfolio/search_model.dart';

class SearchApi {
  final Dio _dio = Dio();
  Future<List<SearchData>> getSearchData(String query, int portfolio) async {
    try {
      final response = await _dio.get(
        "$searchPortfolio/$portfolio/?search=$query",
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

      List<SearchData> searchDataList = [];
      if (response.statusCode == 200) {
        log("inside search data:::${response.data}");
        final List<dynamic> dataList = response.data;
        for (var searchData in dataList) {
          SearchData searchItem = SearchData.fromJson(searchData);
          searchDataList.add(searchItem);
        }
      }
      log(searchDataList.length.toString());
      return searchDataList;
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
