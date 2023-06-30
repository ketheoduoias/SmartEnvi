class AddressModel {
  List<ProvinceModel>? data;
  String? dataDate;
  int? generateDate;

  AddressModel({this.data, this.dataDate, this.generateDate});

  AddressModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProvinceModel>[];
      json['data'].forEach((v) {
        data!.add(ProvinceModel.fromJson(v));
      });
    }
    dataDate = json['data_date'];
    generateDate = json['generate_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['data_date'] = dataDate;
    data['generate_date'] = generateDate;
    return data;
  }
}

class ProvinceModel {
  String? id;
  String? name;
  String? type;
  List<List<List<List<double>>>>? coordinates;
  List<double>? bbox;
  List<DistrictModel>? districts;

  ProvinceModel({this.id, this.name, this.type, this.districts});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    id = json['level1_id'];
    name = json['name'];
    type = json['type'];
    if (json['coordinates'] != null) {
      if (type == "Polygon") {
        var sub = (json['coordinates'] as List)
            .map((e) => (e as List)
                .map((e) => (e as List).map((e) => e as double).toList())
                .toList())
            .toList();
        coordinates = [sub];
      } else {
        coordinates = (json['coordinates'] as List)
            .map((e) => (e as List)
                .map((e) => (e as List)
                    .map((e) => (e as List).map((e) => e as double).toList())
                    .toList())
                .toList())
            .toList();
      }
    }
    if (json['bbox'] != null) {
      bbox = (json['bbox'] as List).map((e) => e as double).toList();
    }
    if (json['level2s'] != null) {
      districts = <DistrictModel>[];
      json['level2s'].forEach((v) {
        districts!.add(DistrictModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level1_id'] = id;
    data['name'] = name;
    data['type'] = type;
    if (districts != null) {
      data['level2s'] = districts!.map((v) => v.toJson()).toList();
    }
    data['coordinates'] = coordinates;
    data['bbox'] = bbox;
    return data;
  }
}

class DistrictModel {
  String? id;
  String? name;
  String? type;
  List<List<List<List<double>>>>? coordinates;
  List<double>? bbox;
  List<WardModel>? wards;

  DistrictModel({this.id, this.name, this.type, this.wards});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    id = json['level2_id'];
    name = json['name'];
    type = json['type'];
    if (json['coordinates'] != null) {
      if (type == "Polygon") {
        var sub = (json['coordinates'] as List)
            .map((e) => (e as List)
                .map((e) => (e as List).map((e) => e as double).toList())
                .toList())
            .toList();
        coordinates = [sub];
      } else {
        coordinates = (json['coordinates'] as List)
            .map((e) => (e as List)
                .map((e) => (e as List)
                    .map((e) => (e as List).map((e) => e as double).toList())
                    .toList())
                .toList())
            .toList();
      }
    }
    if (json['bbox'] != null) {
      bbox = (json['bbox'] as List).map((e) => e as double).toList();
    }
    if (json['level3s'] != null) {
      wards = <WardModel>[];
      json['level3s'].forEach((v) {
        wards!.add(WardModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level2_id'] = id;
    data['name'] = name;
    data['type'] = type;
    if (wards != null) {
      data['level3s'] = wards!.map((v) => v.toJson()).toList();
    }
    data['coordinates'] = coordinates;
    data['bbox'] = bbox;
    return data;
  }
}

class WardModel {
  String? id;
  String? name;
  String? type;

  WardModel({this.id, this.name, this.type});

  WardModel.fromJson(Map<String, dynamic> json) {
    id = json['level3_id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level3_id'] = id;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}

class ParseAddressResponse {
  String? provinceId;
  String? provinceName;
  String? districtId;
  String? districtName;

  ParseAddressResponse(
      {this.provinceId, this.provinceName, this.districtId, this.districtName});
  ParseAddressResponse.fromJson(Map<String, dynamic> json) {
    provinceId = json["provinceId"];
    provinceName = json["provinceName"];
    districtId = json["districtId"];
    districtName = json["districtName"];
  }
}
