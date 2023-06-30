import 'package:flutter/material.dart';
import 'package:pollution_environment/model/area_forest_model.dart';

import '../../../../services/commons/helper.dart';

class IQAirCell extends StatelessWidget {
  const IQAirCell(
      {Key? key, required this.areaForestModel, required this.onTap})
      : super(key: key);

  final Function() onTap;
  final AreaForestModel areaForestModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          // height: 120,
          padding: const EdgeInsets.all(5),
          child: IntrinsicHeight(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                  flex: 3,
                  child: Card(
                    color: getColorRank(int.parse(areaForestModel.rank ?? "0")),
                    child: Center(
                      child: Text(
                        areaForestModel.rank ?? "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                    ),
                  )),
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 14,
                child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        areaForestModel.country ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text.rich(TextSpan(text: "Diện tích rừng: ", children: [
                        TextSpan(
                            text: areaForestModel.forestAreaHectares ?? "",
                            style: const TextStyle(color: Colors.cyan)),
                        const TextSpan(text: " hecta")
                      ])),
                      Text.rich(TextSpan(text: "Dân số: ", children: [
                        TextSpan(
                            text: areaForestModel.population2017 ?? "",
                            style: const TextStyle(color: Colors.cyan)),
                        const TextSpan(text: " người")
                      ])),
                      Text.rich(
                        TextSpan(text: "Diện tích/Người: ", children: [
                          TextSpan(
                              text: areaForestModel.sqareMetersPerCapita ?? "",
                              style: const TextStyle(color: Colors.cyan)),
                          const TextSpan(text: " m\u00B2")
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
