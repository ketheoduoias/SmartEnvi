import 'package:flutter/material.dart';
import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';

import '../../../../services/commons/helper.dart';
import 'forescast_item.dart';

class ForescastItemDay extends StatelessWidget {
  const ForescastItemDay({
    Key? key,
    required this.aqiItemDay,
  }) : super(key: key);

  final List<DailyAqiItem> aqiItemDay;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          // height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return const ForecastItem(
                  title: "Ngày",
                  avg: 'Trung bình',
                  min: 'Nhỏ nhất',
                  max: 'Lớn nhất',
                );
              } else {
                return ForecastItem(
                  title: convertDateFormat(
                          aqiItemDay[index - 1].day ?? "", "dd/MM") ??
                      "",
                  avg: aqiItemDay[index - 1].avg.toString(),
                  min: aqiItemDay[index - 1].min.toString(),
                  max: aqiItemDay[index - 1].max.toString(),
                );
              }
            },
            itemCount: aqiItemDay.length + 1,
          ),
        ),
      ),
    );
  }
}
