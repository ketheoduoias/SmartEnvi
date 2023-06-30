import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pollution_environment/model/user_response.dart';

import '../../../../services/commons/generated/assets.dart';

class ProfilePic extends StatelessWidget {
  final UserModel? user;

  const ProfilePic({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10000.0),
            child: user?.avatar == null
                ? Image.asset(Assets.profileAvatar)
                : CachedNetworkImage(
                    imageUrl: user?.avatar ?? "",
                    height: 30,
                    width: 30,
                    fit: BoxFit.fill,
                    placeholder: (ctx, str) {
                      return Image.asset(Assets.profileAvatar);
                    },
                    errorWidget: (ctx, str, _) {
                      return Image.asset(Assets.profileAvatar);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
