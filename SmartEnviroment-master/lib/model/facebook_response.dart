class FBNewsResponse {
  List<FBNews>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  FBNewsResponse(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  FBNewsResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <FBNews>[];
      json['results'].forEach((v) {
        results!.add(FBNews.fromJson(v));
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

class FBNews {
  String? id;
  String? permalinkUrl;
  String? message;
  String? fullPicture;
  From? from;
  String? objectId;
  String? createdTime;
  String? type;

  FBNews(
      {this.id,
      this.permalinkUrl,
      this.message,
      this.fullPicture,
      this.from,
      this.objectId,
      this.createdTime,
      this.type});

  FBNews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    permalinkUrl = json['permalink_url'];
    message = json['message'];
    fullPicture = json['full_picture'];
    from = json['from'] != null ? From.fromJson(json['from']) : null;
    objectId = json['object_id'];
    createdTime = json['created_time'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['permalink_url'] = permalinkUrl;
    data['message'] = message;
    data['full_picture'] = fullPicture;
    if (from != null) {
      data['from'] = from!.toJson();
    }
    data['object_id'] = objectId;
    data['created_time'] = createdTime;
    data['type'] = type;
    return data;
  }
}

class From {
  String? name;
  String? id;

  From({this.name, this.id});

  From.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
