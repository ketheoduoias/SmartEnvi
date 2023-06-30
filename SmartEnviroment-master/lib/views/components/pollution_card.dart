import 'package:flutter/material.dart';
import 'package:pollution_environment/model/pollution_response.dart';

import '../../services/commons/helper.dart';

class PollutionCard extends StatelessWidget {
  const PollutionCard({Key? key, required this.pollutionModel})
      : super(key: key);

  final PollutionModel pollutionModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Image.asset(
                  getAssetPollution(pollutionModel.type),
                ),
                color: getQualityColor(pollutionModel.qualityScore),
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
                      getQualityColor(pollutionModel.qualityScore)
                          .withAlpha(220),
                      getQualityColor(pollutionModel.qualityScore)
                          .withAlpha(170),
                      getQualityColor(pollutionModel.qualityScore)
                          .withAlpha(250),
                      getQualityColor(pollutionModel.qualityScore)
                          .withAlpha(100),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Chất lượng",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: getTextColorRank(
                              pollutionModel.qualityScore ?? 0)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      getQualityText(pollutionModel.qualityScore),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: getTextColorRank(
                              pollutionModel.qualityScore ?? 0)),
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
