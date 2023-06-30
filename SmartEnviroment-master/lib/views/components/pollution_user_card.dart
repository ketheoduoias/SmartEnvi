import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/views/components/username.dart';

import '../../services/commons/generated/assets.dart';
import '../../services/commons/helper.dart';

class PollutionUserCard extends StatelessWidget {
  const PollutionUserCard({Key? key, required this.userModel, this.createdAt})
      : super(key: key);

  final UserModel? userModel;
  final String? createdAt;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: userModel?.avatar == null
                  ? Image.asset(
                      Assets.profileAvatar,
                      width: 50,
                      height: 50,
                    )
                  : CachedNetworkImage(
                      imageUrl: userModel!.avatar!,
                      placeholder: (c, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (c, e, f) => Center(
                          child: Image.asset(
                        Assets.profileAvatar,
                        width: 50,
                        height: 50,
                      )),
                      fit: BoxFit.fill,
                      width: 50,
                      height: 50,
                    ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dữ liệu được cung cấp bởi",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  UserName(user: userModel ?? UserModel(name: "")),
                  Text(
                    "Cập nhật lần cuối: ${timeAgoSinceDate(dateStr: createdAt ?? "")}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
