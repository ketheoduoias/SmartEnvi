import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    this.title,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);
  final String? title;
  final String? content;
  final String? confirmText;
  final String? cancelText;
  final Function? onConfirm;
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Text(
                title ?? "",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            height: 44,
          ),
          Container(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      content ?? "",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (onCancel != null)
                          ElevatedButton(
                            onPressed: () {
                              onCancel == null ? Get.back() : onCancel!();
                            },
                            child: Text(cancelText ?? "Hủy"),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                fixedSize: MaterialStateProperty.all(
                                  Size(
                                      (MediaQuery.of(context).size.width - 80) /
                                          2,
                                      44),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey)),
                          ),
                        if (onConfirm != null)
                          ElevatedButton(
                            onPressed: () {
                              onConfirm == null ? Get.back() : onConfirm!();
                            },
                            child: Text(confirmText ?? "Đồng ý"),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all(
                                Size(
                                    (MediaQuery.of(context).size.width - 80) /
                                        2,
                                    44),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
