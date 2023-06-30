import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pollution_environment/model/facebook_response.dart';

import '../../../../services/commons/helper.dart';

class FBPostCell extends StatelessWidget {
  const FBPostCell({Key? key, required this.fbNews, required this.onTap})
      : super(key: key);

  final Function() onTap;
  final FBNews fbNews;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          // height: 120,
          padding: const EdgeInsets.all(5),
          child: IntrinsicHeight(
            child: Row(children: [
              Expanded(
                flex: 6,
                child: CachedNetworkImage(
                  imageUrl: fbNews.fullPicture ??
                      "https://via.placeholder.com/120/?text=Smart%20Environment",
                  placeholder: (c, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (c, e, f) =>
                      const Center(child: Icon(Icons.error)),
                  fit: BoxFit.fill,
                ),
              ),
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
                        fbNews.message ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        fbNews.from?.name ?? "",
                        style: const TextStyle(color: Colors.cyan),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(convertDate(fbNews.createdTime ?? "") ?? ""),
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
