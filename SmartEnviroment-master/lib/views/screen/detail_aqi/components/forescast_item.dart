import 'package:flutter/material.dart';

import '../../../../services/commons/helper.dart';

class ForecastItem extends StatelessWidget {
  const ForecastItem(
      {Key? key,
      required this.title,
      required this.avg,
      required this.min,
      required this.max})
      : super(key: key);
  final String title;
  final String avg;
  final String min;
  final String max;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 80,
            child: Text(
              avg,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getQualityColor(getAQIRank(double.tryParse(avg)))),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 80,
            child: Text(
              min,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getQualityColor(getAQIRank(double.tryParse(min)))),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 80,
            child: Text(
              max,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getQualityColor(getAQIRank(double.tryParse(max)))),
            ),
          ),
        ],
      ),
    );
  }
}
