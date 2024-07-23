class NotificationModel {
  int? id;
  String? createdAt;
  bool? readMessage;
  String? message;
  String? notificationType;
  List<MetaDataNotification>? metaData;
  int? user;

  NotificationModel({
    this.id,
    this.createdAt,
    this.readMessage,
    this.message,
    this.notificationType,
    this.metaData,
    this.user,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      createdAt: json['created_at']?.toString(),
      readMessage: json['read_message'] == true,
      message: json['message']?.toString(),
      notificationType: json['notification_type']?.toString(),
      metaData: json['meta_data'] != null
          ? (json['meta_data'] as List)
              .map((item) => MetaDataNotification.fromJson(item))
              .toList()
          : null,
      user: json['user'] is int
          ? json['user']
          : int.tryParse(json['user'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'read_message': readMessage,
      'message': message,
      'notification_type': notificationType,
      'meta_data': metaData?.map((item) => item.toJson()).toList(),
      'user': user,
    };
  }
}

class MetaDataNotification {
  String? tripId;

  MetaDataNotification({this.tripId});

  factory MetaDataNotification.fromJson(Map<String, dynamic> json) {
    return MetaDataNotification(
      tripId: json['trip_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
    };
  }
}
