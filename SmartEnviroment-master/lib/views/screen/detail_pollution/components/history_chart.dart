import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pollution_environment/model/pollution_response.dart';

import '../../../../services/commons/helper.dart';

class HistoryPollutionData {
  double land = 0;
  double water = 0;
  double air = 0;
  double sound = 0;
}

class HistoryChart extends StatelessWidget {
  HistoryChart({Key? key, required this.pollutions}) : super(key: key);
  final List<PollutionModel> pollutions;
  static const waterColor = Color(0xff0293ee);
  static const landColor = Color(0xfff8b250);
  static const airColor = Color(0xff13d38e);
  static const soundColor = Color(0xff845bef);
  static const betweenSpace = 0.0;
  final Map<String, HistoryPollutionData> data = {};
  void initData() {
    for (var pollution in pollutions) {
      String? date = pollution.createdAt;
      if (date != null) {
        String? newDate = convertDateFormat(date, "yyyy/MM/dd");
        if (newDate != null) {
          HistoryPollutionData? dataDate = data[newDate];
          dataDate ??= HistoryPollutionData();
          if (pollution.type == "air") dataDate.air += 1;
          if (pollution.type == "land") dataDate.land += 1;
          if (pollution.type == "sound") dataDate.sound += 1;
          if (pollution.type == "water") dataDate.water += 1;
          data[newDate] = dataDate;
        }
      }
    }
  }

  BarChartGroupData generateGroupData(
      int x, double land, double water, double air, double sound) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: land,
          color: landColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: land + betweenSpace,
          toY: land + betweenSpace + water,
          color: waterColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: land + betweenSpace + water + betweenSpace,
          toY: land + betweenSpace + water + betweenSpace + air,
          color: airColor,
          width: 5,
        ),
        BarChartRodData(
          fromY:
              land + betweenSpace + water + betweenSpace + air + betweenSpace,
          toY: land +
              betweenSpace +
              water +
              betweenSpace +
              air +
              betweenSpace +
              sound,
          color: soundColor,
          width: 5,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff787694),
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = "";
        break;

      default:
        text = "${value.toInt()}";
    }
    return Padding(
      child: Text(text, style: style),
      padding: const EdgeInsets.only(
        top: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return Card(
      // color: Colors.white,
      // elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lịch sử',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LegendsListWidget(
              legends: [
                Legend("Đất", landColor),
                Legend("Nước", waterColor),
                Legend("Không khí", airColor),
                Legend("Tiếng ồn", soundColor),
              ],
            ),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 2,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(),
                    rightTitles: AxisTitles(),
                    topTitles: AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 25,
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barGroups: data.isNotEmpty
                      ? data.entries
                          .map((e) => generateGroupData(
                              int.parse(e.key.substring(e.key.length - 2)),
                              e.value.land,
                              e.value.water,
                              e.value.air,
                              e.value.sound))
                          .toList()
                      : [generateGroupData(0, 0, 0, 0, 0)],
                  maxY: 10 + (betweenSpace * 3),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Dữ liệu ô nhiễm trong 30 ngày gần nhất',
                style: TextStyle(
                  color: Color(0xff757391),
                  fontSize: 13,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegendWidget extends StatelessWidget {
  final String name;
  final Color color;

  const LegendWidget({
    Key? key,
    required this.name,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff757391),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class LegendsListWidget extends StatelessWidget {
  final List<Legend> legends;

  const LegendsListWidget({
    Key? key,
    required this.legends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
              name: e.name,
              color: e.color,
            ),
          )
          .toList(),
    );
  }
}

class Legend {
  final String name;
  final Color color;

  Legend(this.name, this.color);
}
