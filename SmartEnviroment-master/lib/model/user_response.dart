import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:pollution_environment/model/token_response.dart';
import 'package:pollution_environment/services/commons/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthResponse {
  UserModel? user;
  TokensResponse? tokens;

  AuthResponse.fromJson(Map<String, dynamic> json) {
    user = UserModel.fromJson(json['user']);
    tokens = TokensResponse.fromJson(json['tokens']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['tokens'] = tokens;
    return data;
  }
}

class UserListResponse {
  List<UserModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  UserListResponse(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  UserListResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <UserModel>[];
      json['results'].forEach((v) {
        results!.add(UserModel.fromJson(v));
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

class UserModel {
  String? role;
  bool? isEmailVerified;
  String? email;
  String? name;
  String? id;
  String? createdAt;
  String? avatar;
  bool? isNotificationReceived;
  double? lat;
  double? lng;
  List<String> provinceManage = [];
  int post = 0;

  UserModel({this.name});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    isEmailVerified = json['isEmailVerified'];
    isNotificationReceived = json['isNotificationReceived'];
    email = json['email'];
    name = json['name'];
    avatar = json['avatar'];
    createdAt = json['createdAt'];
    lat = json['lat'];
    lng = json['lng'];
    if (json['provinceManage'] != null) {
      provinceManage = <String>[];
      json['provinceManage'].forEach((v) {
        provinceManage.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['isEmailVerified'] = isEmailVerified;
    data['isNotificationReceived'] = isNotificationReceived;
    data['email'] = email;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['avatar'] = avatar;
    data['lat'] = lat;
    data['lng'] = lng;
    data['provinceManage'] = provinceManage;
    return data;
  }
}

class UserStore {
  static final UserStore _singleton = UserStore._internal();
  final String kKeyUid = "kKeyUid";
  factory UserStore() {
    return _singleton;
  }

  UserStore._internal();

  Future<void> saveAuth(AuthResponse authResponse) async {
    // Lưu uid vào pref để sử dụng tracking location
    String? uid = authResponse.user?.id;
    if (uid != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kKeyUid, uid);
    }

    ///
    String user = jsonEncode(authResponse);
    Box box = Hive.box(kHiveBox);
    await box.put(kCurrentUser, user);
  }

  AuthResponse? getAuth() {
    Box box = Hive.box(kHiveBox);
    String? userData = box.get(kCurrentUser);
    if (userData != null) {
      Map<String, dynamic> userMap = jsonDecode(userData);
      var user = AuthResponse.fromJson(userMap);
      return user;
    } else {
      return null;
    }
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString(kKeyUid);
    return uid;
  }

  Future<void> removeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kKeyUid);

    var box = Hive.box(kHiveBox);
    await box.delete(kCurrentUser);
  }
}
