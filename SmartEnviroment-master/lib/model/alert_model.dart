class AlertResponse {
  List<Alert>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  AlertResponse(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  AlertResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Alert>[];
      json['results'].forEach((v) {
        results!.add(Alert.fromJson(v));
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

class Alert {
  List<String>? images;
  List<String>? provinceIds;
  String? title;
  String? content;
  String? userCreated;
  String? createdAt;
  String? updatedAt;
  String? id;

  Alert(
      {this.images,
      this.provinceIds,
      this.title,
      this.content,
      this.userCreated,
      this.createdAt,
      this.updatedAt,
      this.id});

  Alert.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    provinceIds = json['provinceIds'].cast<String>();
    title = json['title'];
    content = json['content'];
    userCreated = json['userCreated'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['images'] = images;
    data['provinceIds'] = provinceIds;
    data['title'] = title;
    data['content'] = content;
    data['userCreated'] = userCreated;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    return data;
  }
}
