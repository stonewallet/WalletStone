class TravelPostResponse {
  String? message;

  TravelPostResponse({this.message});

  TravelPostResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}

class NotificationResponseModel {
  String? message;

  NotificationResponseModel({this.message});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
