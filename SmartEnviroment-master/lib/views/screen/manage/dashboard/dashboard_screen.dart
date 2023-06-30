import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/network/api_service.dart';
import '../components/chart.dart';
import '../components/line_chart.dart';
import '../../../../controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardControler _dashboardControler = Get.put(DashboardControler());
  final CarouselController _carouselController = CarouselController();

  DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildChartList(),
            const SizedBox(
              height: 10,
            ),
            _buildDot(context),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                "Máy chủ",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              subtitle: const Text(baseUrl),
              leading: Icon(
                Icons.computer_rounded,
                color: Theme.of(context).primaryColor,
              ),
              contentPadding: const EdgeInsets.all(0),
            ),
            ListTile(
              title: Text(
                "Ứng dụng",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              subtitle: Obx(
                () => Text(
                    "${_dashboardControler.appName.value} - ${_dashboardControler.version.value} - ${_dashboardControler.buildNumber.value}"),
              ),
              leading: Icon(
                Icons.settings_applications,
                color: Theme.of(context).primaryColor,
              ),
              contentPadding: const EdgeInsets.all(0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartList() {
    return CarouselSlider(
      carouselController: _carouselController,
      items: [
        Obx(() => Chart(
              air: _dashboardControler.airCnt.value,
              land: _dashboardControler.landCnt.value,
              sound: _dashboardControler.soundCnt.value,
              water: _dashboardControler.waterCnt.value,
            )),
        Obx(
          () => LineChartWeek(
            weekAirData: _dashboardControler.weekAirData.toList(),
            weekLandData: _dashboardControler.weekLandData.toList(),
            weekSoundData: _dashboardControler.weekSoundData.toList(),
            weekWaterData: _dashboardControler.weekWaterData.toList(),
          ),
        ),
      ],
      options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 0.9,
          height: 400,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          initialPage: 0,
          disableCenter: true,
          onPageChanged: (index, reason) {
            _dashboardControler.currentChart.value = index;
          }),
    );
  }

  Widget _buildDot(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ["1", "2"].asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _carouselController.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 12.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).primaryColor).withOpacity(
                      _dashboardControler.currentChart.value == entry.key
                          ? 1
                          : 0.2)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
