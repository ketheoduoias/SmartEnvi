import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../services/commons/helper.dart';
import '../../../components/aqi_card.dart';
import '../../detail_aqi/detail_aqi_screen.dart';
import '../../../../controllers/map_controller.dart';

class ViewAQISelected extends StatelessWidget {
  const ViewAQISelected({
    Key? key,
    required MapController controller,
  })  : _controller = controller,
        super(key: key);

  final MapController _controller;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _controller.offset,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {
            Get.to(
              () => DetailAQIScreen(),
              arguments: _controller.aqiMarkerSelected.value?.uid,
            );
          },
          child: Card(
            // width: 200,
            elevation: 5,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 10,
                right: 5,
                left: 5),
            child: ListView(
              padding: const EdgeInsets.all(5),
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text(
                    _controller.aqiMarkerSelected.value?.station?.name ??
                        "Chỉ số AQI",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  subtitle: Text(
                      "Cập nhật lần cuối: ${timeAgoSinceDate(dateStr: _controller.aqiMarkerSelected.value?.station?.time ?? "")}"),
                  trailing: IconButton(
                      onPressed: () {
                        Share.share(
                            "Chỉ số không khí tại ${_controller.aqiMarkerSelected.value?.station?.name ?? ""} là ${_controller.aqiMarkerSelected.value?.aqi ?? 0}. Xem chi tiết tại ứng dụng Smart Environment");
                      },
                      icon: const Icon(Icons.share_rounded)),
                ),
                _controller.aqiMarkerSelected.value != null
                    ? AQICard(
                        aqiModel: _controller.aqiMarkerSelected.value!,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
