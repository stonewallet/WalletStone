import 'package:flutter/material.dart';
import 'package:walletstone/API/api_provider.dart';
import 'package:walletstone/Responses/travel_list_response.dart';
import 'package:walletstone/UI/Constants/colors.dart';

class TripProvider extends ChangeNotifier {
  List<TravelList> _travelList = <TravelList>[];

  List<TravelList> get travelList => _travelList;

  Future<void> fetch() async {
    _travelList = await ApiProvider().processTravel();
    notifyListeners();
  }

  Color getButtonColor(int index) {
    if (_travelList.isNotEmpty && index < _travelList.length) {
      bool isEndTrip = _travelList[index].endTrip;
      bool moreThanOneUser = _travelList[index].user.length > 1;
      if (moreThanOneUser) {
        return isEndTrip ? stockGreenColor : redColor;
      } else {
        return isEndTrip ? redColor : whiteColor;
      }
    }
    notifyListeners();
    return Colors.white;
  }
}
