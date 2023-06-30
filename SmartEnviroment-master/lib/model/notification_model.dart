import 'package:pollution_environment/model/pollution_response.dart';

class NotificationResponse {
  List<NotificationModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  NotificationResponse(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <NotificationModel>[];
      json['results'].forEach((v) {
        results!.add(NotificationModel.fromJson(v));
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

class NotificationModel {
  String? user;
  PollutionModel? pollution;
  String? createdAt;
  String? updatedAt;
  String? id;

  NotificationModel(
      {this.user, this.pollution, this.createdAt, this.updatedAt, this.id});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    pollution = json['pollution'] != null
        ? PollutionModel.fromJson(json['pollution'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    if (pollution != null) {
      data['pollution'] = pollution!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    return data;
  }
}
