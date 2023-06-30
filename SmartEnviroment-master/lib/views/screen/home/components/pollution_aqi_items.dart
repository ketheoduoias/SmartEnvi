import 'package:flutter/material.dart';
import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';

import 'pollution_aqi_item.dart';

class PollutionAqiItems extends StatelessWidget {
  const PollutionAqiItems({
    Key? key,
    required this.aqi,
  }) : super(key: key);
  final WAQIIpResponse aqi;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Các chất thành phần",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 85,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (aqi.data?.iaqi?.co?.v != null)
                  PollutionAQIItem(
                    title: "CO",
                    value: aqi.data?.iaqi?.co?.v?.toString() ?? "-",
                  ),
                if (aqi.data?.iaqi?.no2?.v != null)
                  PollutionAQIItem(
                    title: "NO\u2082",
                    value: aqi.data?.iaqi?.no2?.v?.toString() ?? "-",
                  ),
                if (aqi.data?.iaqi?.o3?.v != null)
                  PollutionAQIItem(
                    title: "O\u2083",
                    value: aqi.data?.iaqi?.o3?.v?.toString() ?? "-",
                  ),
                if (aqi.data?.iaqi?.pm10?.v != null)
                  PollutionAQIItem(
                    title: "PM\u00B9\u2070",
                    value: aqi.data?.iaqi?.pm10?.v?.toString() ?? "-",
                  ),
                if (aqi.data?.iaqi?.pm25?.v != null)
                  PollutionAQIItem(
                    title: "PM\u00B2\u2075",
                    value: aqi.data?.iaqi?.pm25?.v?.toString() ?? "-",
                  ),
                if (aqi.data?.iaqi?.so2?.v != null)
                  PollutionAQIItem(
                    title: "SO\u2082",
                    value: aqi.data?.iaqi?.so2?.v?.toString() ?? "-",
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
