

import 'package:flutter/cupertino.dart';
import 'package:walletstone/UI/Model/portfolio/portfolio_model.dart';
import 'package:walletstone/API/portfolio_api/api_services.dart';

class AssetProvider extends ChangeNotifier {
  List<Portfolio> assetList = [];
  List<Portfolio> loanList = [];
  List<Portfolio> cashList = [];
  final apiService = ApiService();

  getAsset() async {
    assetList = await apiService.getData1();
    notifyListeners();
  }

  getLoans() async {
    loanList = await apiService.getDataForLoan();
    notifyListeners();
  }

  getCash() async {
    cashList = await apiService.getDataForCash();
    notifyListeners();
  }
}
