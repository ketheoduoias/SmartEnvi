class PollutionQuality {
  String? key;
  String? name;
  int? score;

  PollutionQuality({this.key, this.name, this.score});

  PollutionQuality.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['name'] = name;
    data['score'] = score;
    return data;
  }
}
