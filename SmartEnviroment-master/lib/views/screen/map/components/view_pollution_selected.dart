import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/pollution_response.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../services/commons/helper.dart';
import '../../../components/pollution_card.dart';
import '../../detail_pollution/detail_pollution_screen.dart';

class ViewPollutionSelected extends StatelessWidget {
  const ViewPollutionSelected(
      {Key? key,
      required this.offset,
      required this.pollutionSelected,
      required this.currentUser})
      : super(key: key);
  final Animation<Offset> offset;
  final PollutionModel? pollutionSelected;
  final UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    String status = "";
    if (currentUser?.role == "admin" || currentUser?.role == "mod") {
      if (pollutionSelected?.status == 0) {
        status = "\nĐang chờ duyệt";
      } else if (pollutionSelected?.status == 1) {
        status = "\nĐã được duyệt";
      } else if (pollutionSelected?.status == 2) {
        status = "\nTừ chối duyệt";
      }
    }
    return SlideTransition(
        position: offset,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
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
                        "${pollutionSelected?.specialAddress ?? ""}, ${pollutionSelected?.wardName ?? ""}, ${pollutionSelected?.districtName ?? ""}, ${pollutionSelected?.provinceName ?? ""}",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                            text: "Cập nhật lần cuối: ${timeAgoSinceDate(
                              dateStr: pollutionSelected?.createdAt ?? "",
                            )}",
                            style: Theme.of(context).textTheme.caption,
                            children: [
                              TextSpan(
                                  text: status,
                                  style: TextStyle(
                                      color: pollutionSelected?.status == 0
                                          ? Colors.orange
                                          : pollutionSelected?.status == 1
                                              ? Colors.green
                                              : Colors.red))
                            ]),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Share.share(
                              "Chất lượng ${getShortNamePollution(pollutionSelected?.type)} tại ${pollutionSelected?.wardName ?? ""}, ${pollutionSelected?.districtName ?? ""}, ${pollutionSelected?.provinceName ?? ""} đang ${getQualityText(pollutionSelected?.qualityScore)}. Xem chi tiết tại ứng dụng Smart Environment");
                        },
                        icon: const Icon(Icons.share_rounded),
                      )),
                  pollutionSelected != null
                      ? PollutionCard(
                          pollutionModel: pollutionSelected!,
                        )
                      : Container(),
                ],
              ),
            ),
            onTap: () {
              Get.to(() => DetailPollutionScreen(),
                  arguments: pollutionSelected?.id);
            },
          ),
        ));
  }
}
