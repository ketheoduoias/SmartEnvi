import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pollution_environment/model/news_model.dart';

class NewsCell extends StatelessWidget {
  const NewsCell({Key? key, required this.newsModel, required this.onTap})
      : super(key: key);

  final Function() onTap;
  final NewsModel newsModel;
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
                  imageUrl: (newsModel.image ?? []).isNotEmpty
                      ? (newsModel.image ?? []).first
                      : "https://via.placeholder.com/120/?text=Smart%20Environment",
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
                        newsModel.title ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        newsModel.author ?? "",
                        style: const TextStyle(color: Colors.cyan),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text.rich(
                        TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: newsModel.topic ?? "",
                            style: const TextStyle(
                              color: Colors.cyan,
                            ),
                          ),
                          const TextSpan(text: " | "),
                          TextSpan(text: newsModel.time ?? ""),
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
