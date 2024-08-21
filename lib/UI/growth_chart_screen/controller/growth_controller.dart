import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../API/shared_preferences.dart';
import '../../../main.dart';
import '../../Constants/urls.dart';
import '../model/growth_chart_model.dart';

class GrowthController extends ChangeNotifier {
  TextEditingController daysController = TextEditingController();

  final Dio _dio = Dio();
  int isSelectedDay = 0;
  int durationDay = 7;

  final Set<int> _selectedItems = {};

  DateTime minDate = DateTime.now();
  DateTime maxDate = DateTime(2000);

  List<ChartData> assetDataList = [];
  List<ChartData> cryptoDataList = [];
  List<ChartData> tripDataList = [];
  List<ChartData> loanDataList = [];
  List<ChartData> cashDataList = [];
  List<ChartData> itemsViewList = [];

  bool isLoading = true;
  String? selectedDropdownValue;

  bool isCryptoEnabled = true;
  bool isAssetEnabled = true;
  bool isLoanEnabled = true;
  bool isCashEnabled = true;
  bool isTripEnabled = true;

  selectDays(value) {
    if (isSelectedDay != value) {
      isSelectedDay = value;
      if (value != 3) {
        selectDuration();
      }
    }
    notifyListeners();
  }

  selectDuration() async {
    if (isSelectedDay == 0) {
      durationDay = 7;
    } else if (isSelectedDay == 1) {
      durationDay = 30;
    } else if (isSelectedDay == 2) {
      durationDay = 90;
    } else if (isSelectedDay == 3) {
      durationDay = int.parse(daysController.text);
    }
    log("Duration:$durationDay");
    await fetchDataForLineChart();
  }

  void toggleItem(int index) {
    if (_selectedItems.contains(index)) {
      _selectedItems.remove(index);
    } else {
      _selectedItems.add(index);
    }
    toggleLineInGraph(index);
    notifyListeners();
  }

  toggleLineInGraph(index) {
    if (_selectedItems.contains(index)) {
      if (index == 0) {
        isCryptoEnabled = false;
      } else if (index == 1) {
        isAssetEnabled = false;
      } else if (index == 2) {
        isCashEnabled = false;
      } else if (index == 3) {
        isLoanEnabled = false;
      } else if (index == 4) {
        isTripEnabled = false;
      }
    } else {
      if (index == 0) {
        isCryptoEnabled = true;
      } else if (index == 1) {
        isAssetEnabled = true;
      } else if (index == 2) {
        isCashEnabled = true;
      } else if (index == 3) {
        isLoanEnabled = true;
      } else if (index == 4) {
        isTripEnabled = true;
      }
    }
    notifyListeners();
  }

  bool isSelectedItem(int index) {
    return _selectedItems.contains(index);
  }

  toggelItemsBuilder() {
    if (selectedDropdownValue == 'Crypto') {
      itemsViewList = cryptoDataList;
    } else if (selectedDropdownValue == 'Assets') {
      itemsViewList = assetDataList;
    } else if (selectedDropdownValue == 'Loans') {
      itemsViewList = loanDataList;
    } else if (selectedDropdownValue == 'Cash') {
      itemsViewList = cashDataList;
    } else if (selectedDropdownValue == 'Trips') {
      itemsViewList = tripDataList;
    }
    notifyListeners();
  }

  String formatToThreeDecimals(double value) {
    return value.toStringAsFixed(3);
  }

  Future fetchDataForLineChart() async {
    setupHttpOverrides();
    try {
      log('inside fetch');
      final response = await _dio.get(
        "$baseUrl/travel/get/charts/?days=$durationDay",
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
        final data = response.data;

        log("response Data:: $data");
        // final GrowthChartData chartData = GrowthChartData.fromJson(data);
        // log("response Crypto:: ${data['crypto_data']}");

        cryptoDataList = _mapToChartData(data['crypto_data']);
        assetDataList = _mapToChartData(data['assets_data']);
        loanDataList = _mapToChartData(data['loans_data']);
        tripDataList = _mapToChartData(data['trips_data']);
        cashDataList = _mapToChartData(data['cash_data']);
        toggelItemsBuilder();
        notifyListeners();
        isLoading = false;
        return data;
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

  List<ChartData> _mapToChartData(List<dynamic> data) {
    List<ChartData> filteredData = [];

    for (var element in data) {
      if (element.length == 3) {
        // Ensure the element has all required fields
        log('Mapping element: $element');
        try {
          // Convert "YYYY/MM/DD" to "YYYY-MM-DD"
          String formattedDate = element[1].toString().replaceAll('/', '-');

          filteredData.add(
            ChartData(
              element[0].toString(),
              DateTime.parse(formattedDate),
              double.parse(element[2].toString()),
            ),
          );
        } catch (e) {
          log('Error parsing element $element: $e');
        }
      } else {
        log('Skipping element due to missing fields: $element');
      }
    }

    // for (ChartData element in filteredData) {
    //   log("${element.name} :: ${element.date}");
    // }
    return filteredData;
  }

  String formatDate(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  }

  findMinAndMaxDate() {
    // Find the earliest date in the data
    List<List<ChartData>> allDataLists = [
      cryptoDataList,
      assetDataList,
      cashDataList,
      loanDataList,
      tripDataList
    ];

    for (var dataList in allDataLists) {
      if (dataList.isNotEmpty) {
        DateTime currentMin =
            dataList.map((d) => d.date).reduce((a, b) => a.isBefore(b) ? a : b);
        DateTime currentMax =
            dataList.map((d) => d.date).reduce((a, b) => a.isAfter(b) ? a : b);

        if (currentMin.isBefore(minDate)) minDate = currentMin;
        if (currentMax.isAfter(maxDate)) maxDate = currentMax;
      }
    }
  }
}
