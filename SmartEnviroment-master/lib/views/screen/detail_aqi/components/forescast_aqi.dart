import 'package:flutter/material.dart';
import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';

import 'forescast_item_day.dart';

class ForescastAqi extends StatefulWidget {
  const ForescastAqi(this.daily, {Key? key}) : super(key: key);
  final Daily daily;
  @override
  ForescastAqiState createState() => ForescastAqiState();
}

class ForescastAqiState extends State<ForescastAqi>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          const Text(
            "Dự báo",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 50,
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Theme.of(context).primaryColor,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: Theme.of(context).primaryColor,
              indicatorPadding: const EdgeInsets.all(8),
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  text: "O₃",
                ),
                Tab(
                  text: "PM¹⁰",
                ),
                Tab(
                  text: "PM²⁵",
                ),
                Tab(
                  text: "UVI",
                ),
              ],
              controller: tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                ForescastItemDay(
                  aqiItemDay: widget.daily.o3 ?? [],
                ),
                ForescastItemDay(
                  aqiItemDay: widget.daily.pm10 ?? [],
                ),
                ForescastItemDay(
                  aqiItemDay: widget.daily.pm25 ?? [],
                ),
                ForescastItemDay(
                  aqiItemDay: widget.daily.uvi ?? [],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
