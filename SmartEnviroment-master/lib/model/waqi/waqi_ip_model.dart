class WAQIIpResponse {
  String? status;
  WAQIIpData? data;

  WAQIIpResponse({this.status, this.data});

  WAQIIpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? WAQIIpData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WAQIIpData {
  int? aqi;
  int? idx;
  List<Attributions>? attributions;
  City? city;
  String? dominentpol;
  Iaqi? iaqi;
  Time? time;
  Forecast? forecast;
  Debug? debug;

  WAQIIpData(
      {this.aqi,
      this.idx,
      this.attributions,
      this.city,
      this.dominentpol,
      this.iaqi,
      this.time,
      this.forecast,
      this.debug});

  WAQIIpData.fromJson(Map<String, dynamic> json) {
    aqi = int.tryParse(json['aqi'].toString());
    idx = json['idx'];
    if (json['attributions'] != null) {
      attributions = <Attributions>[];
      json['attributions'].forEach((v) {
        attributions!.add(Attributions.fromJson(v));
      });
    }
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    dominentpol = json['dominentpol'];
    iaqi = json['iaqi'] != null ? Iaqi.fromJson(json['iaqi']) : null;
    time = json['time'] != null ? Time.fromJson(json['time']) : null;
    forecast =
        json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null;
    debug = json['debug'] != null ? Debug.fromJson(json['debug']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aqi'] = aqi;
    data['idx'] = idx;
    if (attributions != null) {
      data['attributions'] = attributions!.map((v) => v.toJson()).toList();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['dominentpol'] = dominentpol;
    if (iaqi != null) {
      data['iaqi'] = iaqi!.toJson();
    }
    if (time != null) {
      data['time'] = time!.toJson();
    }
    if (forecast != null) {
      data['forecast'] = forecast!.toJson();
    }
    if (debug != null) {
      data['debug'] = debug!.toJson();
    }
    return data;
  }
}

class Attributions {
  String? url;
  String? name;
  String? logo;

  Attributions({this.url, this.name, this.logo});

  Attributions.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['name'] = name;
    data['logo'] = logo;
    return data;
  }
}

class City {
  List<double>? geo;
  String? name;
  String? url;
  String? location;

  City({this.geo, this.name, this.url, this.location});

  City.fromJson(Map<String, dynamic> json) {
    geo = json['geo'].cast<double>();
    name = json['name'];
    url = json['url'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['geo'] = geo;
    data['name'] = name;
    data['url'] = url;
    data['location'] = location;
    return data;
  }
}

class Iaqi {
  IAqiItem? co;
  IAqiItem? dew;
  IAqiItem? h;
  IAqiItem? no2;
  IAqiItem? o3;
  IAqiItem? p;
  IAqiItem? pm10;
  IAqiItem? pm25;
  IAqiItem? so2;
  IAqiItem? t;
  IAqiItem? w;

  Iaqi(
      {this.co,
      this.dew,
      this.h,
      this.no2,
      this.o3,
      this.p,
      this.pm10,
      this.pm25,
      this.so2,
      this.t,
      this.w});

  Iaqi.fromJson(Map<String, dynamic> json) {
    co = json['co'] != null ? IAqiItem.fromJson(json['co']) : null;
    dew = json['dew'] != null ? IAqiItem.fromJson(json['dew']) : null;
    h = json['h'] != null ? IAqiItem.fromJson(json['h']) : null;
    no2 = json['no2'] != null ? IAqiItem.fromJson(json['no2']) : null;
    o3 = json['o3'] != null ? IAqiItem.fromJson(json['o3']) : null;
    p = json['p'] != null ? IAqiItem.fromJson(json['p']) : null;
    pm10 = json['pm10'] != null ? IAqiItem.fromJson(json['pm10']) : null;
    pm25 = json['pm25'] != null ? IAqiItem.fromJson(json['pm25']) : null;
    so2 = json['so2'] != null ? IAqiItem.fromJson(json['so2']) : null;
    t = json['t'] != null ? IAqiItem.fromJson(json['t']) : null;
    w = json['w'] != null ? IAqiItem.fromJson(json['w']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (co != null) {
      data['co'] = co!.toJson();
    }
    if (dew != null) {
      data['dew'] = dew!.toJson();
    }
    if (h != null) {
      data['h'] = h!.toJson();
    }
    if (no2 != null) {
      data['no2'] = no2!.toJson();
    }
    if (o3 != null) {
      data['o3'] = o3!.toJson();
    }
    if (p != null) {
      data['p'] = p!.toJson();
    }
    if (pm10 != null) {
      data['pm10'] = pm10!.toJson();
    }
    if (pm25 != null) {
      data['pm25'] = pm25!.toJson();
    }
    if (so2 != null) {
      data['so2'] = so2!.toJson();
    }
    if (t != null) {
      data['t'] = t!.toJson();
    }
    if (w != null) {
      data['w'] = w!.toJson();
    }
    return data;
  }
}

class IAqiItem {
  num? v;

  IAqiItem({this.v});

  IAqiItem.fromJson(Map<String, dynamic> json) {
    v = json['v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['v'] = v;
    return data;
  }
}

class Time {
  String? s;
  String? tz;
  int? v;
  String? iso;

  Time({this.s, this.tz, this.v, this.iso});

  Time.fromJson(Map<String, dynamic> json) {
    s = json['s'];
    tz = json['tz'];
    v = json['v'];
    iso = json['iso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['s'] = s;
    data['tz'] = tz;
    data['v'] = v;
    data['iso'] = iso;
    return data;
  }
}

class Forecast {
  Daily? daily;

  Forecast({this.daily});

  Forecast.fromJson(Map<String, dynamic> json) {
    daily = json['daily'] != null ? Daily.fromJson(json['daily']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (daily != null) {
      data['daily'] = daily!.toJson();
    }
    return data;
  }
}

class Daily {
  List<DailyAqiItem>? o3;
  List<DailyAqiItem>? pm10;
  List<DailyAqiItem>? pm25;
  List<DailyAqiItem>? uvi;

  Daily({this.o3, this.pm10, this.pm25, this.uvi});

  Daily.fromJson(Map<String, dynamic> json) {
    if (json['o3'] != null) {
      o3 = <DailyAqiItem>[];
      json['o3'].forEach((v) {
        o3!.add(DailyAqiItem.fromJson(v));
      });
    }
    if (json['pm10'] != null) {
      pm10 = <DailyAqiItem>[];
      json['pm10'].forEach((v) {
        pm10!.add(DailyAqiItem.fromJson(v));
      });
    }
    if (json['pm25'] != null) {
      pm25 = <DailyAqiItem>[];
      json['pm25'].forEach((v) {
        pm25!.add(DailyAqiItem.fromJson(v));
      });
    }
    if (json['uvi'] != null) {
      uvi = <DailyAqiItem>[];
      json['uvi'].forEach((v) {
        uvi!.add(DailyAqiItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (o3 != null) {
      data['o3'] = o3!.map((v) => v.toJson()).toList();
    }
    if (pm10 != null) {
      data['pm10'] = pm10!.map((v) => v.toJson()).toList();
    }
    if (pm25 != null) {
      data['pm25'] = pm25!.map((v) => v.toJson()).toList();
    }
    if (uvi != null) {
      data['uvi'] = uvi!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyAqiItem {
  int? avg;
  String? day;
  int? max;
  int? min;

  DailyAqiItem({this.avg, this.day, this.max, this.min});

  DailyAqiItem.fromJson(Map<String, dynamic> json) {
    avg = json['avg'];
    day = json['day'];
    max = json['max'];
    min = json['min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avg'] = avg;
    data['day'] = day;
    data['max'] = max;
    data['min'] = min;
    return data;
  }
}

class Debug {
  String? sync;

  Debug({this.sync});

  Debug.fromJson(Map<String, dynamic> json) {
    sync = json['sync'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sync'] = sync;
    return data;
  }
}
