class Check2FAuth {
  bool? message;

  Check2FAuth({this.message});

  Check2FAuth.fromJson(Map<String, dynamic> json) {
    message = json['has_2FAEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['has_2FAEnabled'] = message;
    return data;
  }
}


class CheckAuthStatus {
  bool? message;

  CheckAuthStatus({this.message});

  CheckAuthStatus.fromJson(Map<String, dynamic> json) {
    message = json['has_2fa_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['has_2fa_enabled'] = message;
    return data;
  }
}