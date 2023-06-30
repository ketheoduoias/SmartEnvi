class NewsModel {
  String? id;
  String? link;
  String? title;
  String? topic;
  String? author;
  String? time;
  String? content;
  List<String>? image;
  List<Tags>? tags;

  NewsModel(
      {this.id,
      this.link,
      this.title,
      this.topic,
      this.author,
      this.time,
      this.content,
      this.image,
      this.tags});

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    title = json['title'];
    topic = json['topic'];
    author = json['author'];
    time = json['time'];
    content = json['content'];
    image = json['image'].cast<String>();
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['link'] = link;
    data['title'] = title;
    data['topic'] = topic;
    data['author'] = author;
    data['time'] = time;
    data['content'] = content;
    data['image'] = image;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tags {
  String? tagName;
  String? tagLink;

  Tags({this.tagName, this.tagLink});

  Tags.fromJson(Map<String, dynamic> json) {
    tagName = json['tag_name'];
    tagLink = json['tag_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag_name'] = tagName;
    data['tag_link'] = tagLink;
    return data;
  }
}

class NewsResponse {
  List<NewsModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  NewsResponse(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  NewsResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <NewsModel>[];
      json['results'].forEach((v) {
        results!.add(NewsModel.fromJson(v));
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
