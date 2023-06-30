import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/area_forest_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../services/commons/helper.dart';
import '../../../components/empty_view.dart';
import '../components/iqair_cell.dart';
import '../../../../controllers/iqair_controller.dart';

class IQAirScreen extends StatelessWidget {
  final IQAirController _controller = Get.put(IQAirController());

  IQAirScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: const ClassicHeader(
            idleText: "Kéo để làm mới",
            refreshingText: "Đang tải...",
            releaseText: "Kéo để làm mới",
            completeText: "Lấy dữ liệu thành công",
            refreshStyle: RefreshStyle.Follow,
          ),
          controller: _controller.refreshController.value,
          onRefresh: _controller.onRefresh,
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  itemBuilder: (ctx, index) {
                    return _buildVNRank(
                        ctx, _controller.iqAirRankVN.toList()[index]);
                  },
                  itemCount: _controller.iqAirRankVN.toList().length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                _buildAreaRank(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVNRank(BuildContext context, IQAirRankVN iqAirRankVN) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).cardColor.withOpacity(0.5),
        child: ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: true,
            ),
            header: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  iqAirRankVN.title ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                )),
            collapsed: Container(),
            expanded: (iqAirRankVN.rankData ?? []).isEmpty
                ? const EmptyView()
                : ListView.separated(
                    itemBuilder: (ctx, index) {
                      return index == 0
                          ? const ListTile(
                              leading: Text(
                                "#",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              title: Text("Thành phố",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              trailing: Text("AQI",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            )
                          : ListTile(
                              leading: Text("$index"),
                              title: Text(
                                  iqAirRankVN.rankData?[index - 1].name ?? ""),
                              trailing: Container(
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: getColorRank(int.parse(iqAirRankVN
                                            .rankData?[index - 1].score ??
                                        "0"))),
                                child: Center(
                                  child: Text(
                                    iqAirRankVN.rankData?[index - 1].score ??
                                        "",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                    },
                    itemCount: (iqAirRankVN.rankData?.length ?? 0) + 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
            builder: (_, collapsed, expanded) {
              return Padding(
                padding: const EdgeInsets.only(left: 2, right: 2, bottom: 5),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme: const ExpandableThemeData(crossFadePoint: 0),
                ),
              );
            },
          ),
        ),
      ),
    ));
  }

  Widget _buildAreaRank(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).cardColor.withOpacity(0.5),
        child: ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: true,
            ),
            header: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Bảng xếp hạng diện tích rừng",
                  style: Theme.of(context).textTheme.titleMedium,
                )),
            collapsed: Container(),
            expanded: Obx(
              () => _controller.areaForests.toList().isEmpty
                  ? const EmptyView()
                  : ListView.builder(
                      itemBuilder: (ctx, index) {
                        return IQAirCell(
                          areaForestModel:
                              _controller.areaForests.toList()[index],
                          onTap: () {},
                        );
                      },
                      itemCount: _controller.areaForests.toList().length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
            ),
            builder: (_, collapsed, expanded) {
              return Padding(
                padding: const EdgeInsets.only(left: 2, right: 2, bottom: 5),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme: const ExpandableThemeData(crossFadePoint: 0),
                ),
              );
            },
          ),
        ),
      ),
    ));
  }
}
