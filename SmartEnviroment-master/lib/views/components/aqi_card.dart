import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pollution_environment/model/waqi/waqi_map_model.dart';

import '../../services/commons/helper.dart';

class AQICard extends StatelessWidget {
  const AQICard({Key? key, required this.aqiModel}) : super(key: key);

  final WAQIMapData aqiModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        height: 90,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: SvgPicture.asset(
                    getAssetAQI(
                        getAQIRank(double.tryParse(aqiModel.aqi ?? "-"))),
                    color: Colors.black,
                  ),
                ),
                color: getQualityColor(
                    getAQIRank(double.tryParse(aqiModel.aqi ?? "-"))),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [
                      0.1,
                      0.4,
                      0.6,
                      0.9,
                    ],
                    colors: [
                      getQualityColor(
                              getAQIRank(double.tryParse(aqiModel.aqi ?? "-")))
                          .withAlpha(220),
                      getQualityColor(
                              getAQIRank(double.tryParse(aqiModel.aqi ?? "-")))
                          .withAlpha(170),
                      getQualityColor(
                              getAQIRank(double.tryParse(aqiModel.aqi ?? "-")))
                          .withAlpha(250),
                      getQualityColor(
                              getAQIRank(double.tryParse(aqiModel.aqi ?? "-")))
                          .withAlpha(100),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Center(
                        child: ListTile(
                          title: Text(
                            aqiModel.aqi ?? "-",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          subtitle: const Text(
                            "AQI Mỹ",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Center(
                          child: Text(
                            getQualityAQIText(getAQIRank(
                                double.tryParse(aqiModel.aqi ?? "-"))),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: getTextColorRank(getAQIRank(
                                        double.tryParse(aqiModel.aqi ?? "-")))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
    );
  }
}
