import 'alert_model.dart';

class NotificationAlertResponse {
  List<NotificationAlert>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  NotificationAlertResponse(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  NotificationAlertResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <NotificationAlert>[];
      json['results'].forEach((v) {
        results!.add(NotificationAlert.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    return data;
  }
}

class NotificationAlert {
  Alert? alert;
  String? user;
  String? createdAt;
  String? updatedAt;
  String? id;

  NotificationAlert(
      {this.alert, this.user, this.createdAt, this.updatedAt, this.id});

  NotificationAlert.fromJson(Map<String, dynamic> json) {
    alert = json['alert'] != null ? Alert.fromJson(json['alert']) : null;
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (alert != null) {
      data['alert'] = alert!.toJson();
    }
    data['user'] = user;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    return data;
  }
}
