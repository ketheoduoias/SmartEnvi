import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../services/commons/helper.dart';
import '../../../components/marquee.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({Key? key, required this.title, required this.url})
      : super(key: key);

  final String? url;
  final String? title;

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetailScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late WebViewController _webViewController;

  double _progressLoading = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              // elevation: 0.5,
              // shape: Border.all(width: 0.5),
              color: Theme.of(context).cardColor.withOpacity(1),
              offset: const Offset(0, kToolbarHeight),
              itemBuilder: (ctx) {
                return <PopupMenuItem>[
                  PopupMenuItem(
                    child: ListTile(
                      horizontalTitleGap: 5,
                      contentPadding: const EdgeInsets.all(5),
                      minVerticalPadding: 5,
                      minLeadingWidth: 5,
                      leading: const Icon(Icons.share_rounded),
                      title: const Text("Chia sẻ"),
                      onTap: () {
                        Share.share("Truy cập địa chỉ ${widget.url ?? ""}",
                                subject: widget.title)
                            .then((value) => Get.back());
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      horizontalTitleGap: 5,
                      contentPadding: const EdgeInsets.all(5),
                      minVerticalPadding: 5,
                      minLeadingWidth: 5,
                      leading: const Icon(Icons.copy_rounded),
                      title: const Text("Sao chép liên kết"),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.url))
                            .then((value) {
                          Fluttertoast.showToast(msg: "Đã sao chép liên kết");
                          Get.back();
                        });
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      horizontalTitleGap: 5,
                      contentPadding: const EdgeInsets.all(5),
                      minVerticalPadding: 5,
                      minLeadingWidth: 5,
                      leading: const Icon(Icons.login_rounded),
                      title: const Text("Mở bằng trình duyệt"),
                      onTap: () {
                        launchUrl(
                          Uri.parse(widget.url ?? ""),
                        ).onError((error, stackTrace) {
                          showAlert(
                              desc:
                                  "Không thể mở bằng trình duyệt, vui lòng thử lại sau!");
                          throw ('Can not open url');
                        });
                        Get.back();
                      },
                    ),
                  ),
                ];
              })
        ],
        title: ListTile(
          minVerticalPadding: 0,
          contentPadding: const EdgeInsets.all(0),
          title: MarqueeWidget(
              direction: Axis.horizontal,
              child: Text(
                widget.title ?? "",
                maxLines: 1,
              )),
          subtitle: Text(
            widget.url ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        bottom: _progressLoading >= 1.0
            ? null
            : PreferredSize(
                preferredSize: const Size(double.infinity, 1.0),
                child: MyLinearProgressIndicator(
                  // backgroundColor: Colors.orange,
                  value: _progressLoading,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            setState(() {
              _progressLoading = progress.toDouble() / 100.0;
            });
            _webViewController
                .runJavascript("javascript:(function() { "
                    "var head = document.getElementsByClassName('l-nav')[0];"
                    "head.remove('c-header');"
                    "})()")
                .then((value) => debugPrint('Page finished loading Javascript'))
                .catchError((onError) => debugPrint('$onError'));
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            if (kDebugMode) {
              print('Page started loading: $url');
            }
          },
          onPageFinished: (String url) {
            if (kDebugMode) {
              print('Page finished loading: $url');
            }
            // hideLoading();
            _webViewController
                .runJavascript("javascript:(function() { "
                    "var footer = document.getElementsByClassName('l-footer')[0];"
                    "footer.remove('l-footer');"
                    "var powered = document.getElementsByClassName('c-powered')[0];"
                    "powered.remove('c-powered');"
                    "})()")
                .then((value) => debugPrint('Page finished loading Javascript'))
                .catchError((onError) => debugPrint('$onError'));
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
         /*  Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          ); */
           ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message.message)),
      );
        });
  }
}

class MyLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  const MyLinearProgressIndicator({
    Key? key,
    double? value,
    Color? backgroundColor,
    Animation<Color>? valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        );

  @override
  final Size preferredSize = const Size(double.infinity, 2);
}
