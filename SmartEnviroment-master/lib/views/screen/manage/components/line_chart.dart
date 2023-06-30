import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  const _LineChart(
      {required this.weekAirData,
      required this.weekLandData,
      required this.weekSoundData,
      required this.weekWaterData});
  final List<int> weekAirData;
  final List<int> weekLandData;
  final List<int> weekSoundData;
  final List<int> weekWaterData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      data,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get data => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 1,
        maxX: 7,
        maxY: 300,
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: bottomTitles),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData => [
        lineChartBarWater,
        lineChartBarAir,
        lineChartBarLand,
        lineChartBarSound,
      ];
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return Text("${value.toInt()}", style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 50,
        reservedSize: 30,
      );
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('T2', style: style);
        break;
      case 2:
        text = const Text('T3', style: style);
        break;
      case 3:
        text = const Text('T4', style: style);
        break;
      case 4:
        text = const Text('T5', style: style);
        break;
      case 5:
        text = const Text('T6', style: style);
        break;
      case 6:
        text = const Text('T7', style: style);
        break;
      case 7:
        text = const Text('CN', style: style);
        break;

      default:
        text = const Text('');
        break;
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarWater => LineChartBarData(
        isCurved: true,
        color: const Color(0xff0293ee),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: weekWaterData
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
            .toList()
            .where((element) => element.x != 0)
            .toList(),
      );

  LineChartBarData get lineChartBarLand => LineChartBarData(
      isCurved: true,
      color: const Color(0xfff8b250),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: weekLandData
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList()
          .where((element) => element.x != 0)
          .toList());

  LineChartBarData get lineChartBarSound => LineChartBarData(
      isCurved: true,
      color: const Color(0xff845bef),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: weekSoundData
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList()
          .where((element) => element.x != 0)
          .toList());
  LineChartBarData get lineChartBarAir => LineChartBarData(
      isCurved: true,
      color: const Color(0xff13d38e),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: weekAirData
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList()
          .where((element) => element.x != 0)
          .toList());
}

class LineChartWeek extends StatefulWidget {
  const LineChartWeek(
      {Key? key,
      required this.weekAirData,
      required this.weekLandData,
      required this.weekSoundData,
      required this.weekWaterData})
      : super(key: key);
  final List<int> weekAirData;
  final List<int> weekLandData;
  final List<int> weekSoundData;
  final List<int> weekWaterData;

  @override
  State<StatefulWidget> createState() => LineChartWeekState();
}

class LineChartWeekState extends State<LineChartWeek> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Lượng ô nhiễm trong tuần',
                  style: TextStyle(
                    color: Color(0xff827daa),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: _LineChart(
                      weekAirData: widget.weekAirData,
                      weekLandData: widget.weekLandData,
                      weekSoundData: widget.weekSoundData,
                      weekWaterData: widget.weekWaterData,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
