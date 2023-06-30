import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

import 'alert_notification_screen.dart';
import 'pollution_notification_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thông báo"),
          bottom: TabBar(
            tabs: [
              const Tab(
                icon: Icon(Icons.report_problem_outlined),
                text: "Môi trường",
              ),
              Tab(icon: LineIcon(LineIcons.bullhorn), text: "Khẩn cấp"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NotificationPollutionScreen(),
            NotificationAlertScreen(),
          ],
        ),
      ),
    );
  }
}
