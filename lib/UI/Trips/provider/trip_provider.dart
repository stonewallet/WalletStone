import 'package:flutter/material.dart';
import 'package:walletstone/API/api_provider.dart';
import 'package:walletstone/Responses/travel_list_response.dart';

class TripProvider extends ChangeNotifier {
  List<TravelList> _travelList = <TravelList>[];

  List<TravelList> get travelList => _travelList;

  Future<void> fetch() async {
    _travelList.clear();
    _travelList = await ApiProvider().processTravel();
    notifyListeners();
  }
}
