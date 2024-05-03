class WalletBalanceResponse {
  dynamic message;

  WalletBalanceResponse({this.message});

  WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    message = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = message;
    return data;
  }
}
