import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../services/commons/generated/assets.dart';
import '../../services/commons/helper.dart';

class AQIWeatherCard extends StatelessWidget {
  final WAQIIpResponse aqi;

  const AQIWeatherCard({Key? key, required this.aqi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          SizedBox(
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
                        getAssetAQI(getAQIRank(aqi.data?.aqi?.toDouble())),
                        color: Colors.black,
                      ),
                    ),
                    color:
                        getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble())),
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
                          getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                              .withAlpha(220),
                          getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                              .withAlpha(170),
                          getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                              .withAlpha(250),
                          getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                              .withAlpha(100),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: ListTile(
                              title: Text(
                                aqi.data?.aqi?.toStringAsFixed(1) ?? "-",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              subtitle: const Text(
                                "AQI Mỹ",
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      getQualityAQIText(getAQIRank(
                                          aqi.data?.aqi?.toDouble())),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color: getTextColorRank(
                                                  getAQIRank(aqi.data?.aqi
                                                      ?.toDouble()))),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 3, 5, 3),
                                    child: Text(
                                      aqi.data?.dominentpol ?? "",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: getQualityColor(
                                          getAQIRank(aqi.data?.aqi?.toDouble()),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CachedNetworkImage(
                      //   imageUrl:
                      //       'http://openweathermap.org/img/wn/${aqi.data?.current?.weather?.ic ?? ''}@2x.png',
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      SvgPicture.asset(
                        Assets.thermometer,
                        color: Colors.blue,
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${aqi.data?.iaqi?.t?.v ?? 0}°",
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: VerticalDivider(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            children: [
                              Transform.rotate(
                                angle: (aqi.data?.iaqi?.dew?.v ?? 0) *
                                    math.pi /
                                    180,
                                child: const Icon(
                                  Icons.navigation_rounded,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  "${aqi.data?.iaqi?.w?.v ?? 0} km/h",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Assets.raindrop,
                                color: Colors.blue,
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  "${aqi.data?.iaqi?.h?.v ?? 0}%",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Image.asset(
              //   getAssetBgAir(getAQIRank(aqi.data?.aqi?.toDouble())),
              // ),
              WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [
                      getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                          .withOpacity(0.2),
                      getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                          .withOpacity(0.1),
                    ],
                    [
                      getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                          .withOpacity(0.2),
                      getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                          .withOpacity(0.3)
                    ],
                    [
                      getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                          .withOpacity(0.3),
                      getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                          .withOpacity(0.1)
                    ],
                    [
                      getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                          .withOpacity(0.1),
                      getQualityColor(getAQIRank(aqi.data?.aqi?.toDouble()))
                          .withOpacity(0.2)
                    ],
                  ],
                  durations: [18000, 8000, 5000, 12000],
                  heightPercentages: [0.85, 0.86, 0.88, 0.90],
                  blur: const MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.topLeft,
                  gradientEnd: Alignment.bottomRight,
                ),
                waveAmplitude: 0,
                size: const Size(
                  double.infinity,
                  40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl:
                        "https://aqicn.org/air/images/feeds/${aqi.data?.attributions?.first.logo}",
                    errorWidget: (ctx, str, data) => const Icon(
                      Icons.house_outlined,
                      size: 30,
                    ),
                    height: 30,
                    width: 30,
                  ),
                  title: Text(
                    aqi.data?.attributions?.first.name ?? "",
                    maxLines: 2,
                  ),
                  subtitle: Text(
                    "Cập nhật lần cuối: ${timeAgoSinceDate(dateStr: aqi.data?.time?.s ?? "", numericDates: true)}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
    );
  }
}
