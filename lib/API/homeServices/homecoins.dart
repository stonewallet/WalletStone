import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletstone/API/shared_preferences.dart';
import 'package:walletstone/UI/Constants/urls.dart';
import 'package:walletstone/UI/Model/homeCoin/home_coin_model.dart';
import 'package:walletstone/main.dart';

class ApiServiceForHomeCoins {
  final Dio _dio = Dio();
  Future<List<HomeCoin>> getDataForHomeCoins() async {
    setupHttpOverrides();
    try {
      const limit = 15;
      final response = await _dio.get(
        '$baseUrl/travel/home/coins/$limit/',
        options: Options(
          headers: {
            "Cookie":
                "csrftoken=${MySharedPreferences().getCsrfToken(await SharedPreferences.getInstance())}; sessionid=${MySharedPreferences().getSessionId(await SharedPreferences.getInstance())}",
            "X-CSRFToken": MySharedPreferences()
                .getCsrfToken(await SharedPreferences.getInstance())
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        List<HomeCoin> homeCoins =
            data.map((item) => HomeCoin.fromJson(item)).toList();

        return homeCoins;
      } else {
        throw Exception('Failed to load data');
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
