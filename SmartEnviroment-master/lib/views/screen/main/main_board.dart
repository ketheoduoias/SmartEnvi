// import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pollution_environment/views/screen/home/home_screen.dart';

import '../../../services/commons/notification.dart';
import '../../components/keep_alive_wrapper.dart';
import '../map/map_screen.dart';
import '../news/news_screen.dart';
import '../report_user/report_user_screen.dart';

class MainBoard extends StatefulWidget {
  const MainBoard({Key? key}) : super(key: key);

  @override
  _MainBoardState createState() => _MainBoardState();
}

class _MainBoardState extends State<MainBoard> {
  int indexPage = 0;
  // ReceivePort port = ReceivePort();
  final Widget map = KeepAliveWrapper(child: MapScreen());
  final Widget news = const KeepAliveWrapper(child: NewsScreen());
  final Widget home = KeepAliveWrapper(child: HomeScreen());
  final Widget report = const ReportUser();

  List<Widget> listWidgets() {
    return <Widget>[
      home,
      map,
      news,
      report,
    ];
  }

  @override
  void initState() {
    super.initState();
    FCM().setNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: listWidgets(),
        index: indexPage,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.15)),
          ],
        ),
        height: 75 + MediaQuery.of(context).padding.bottom,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
            child: GNav(
              activeColor: Colors.white,
              iconSize: 26,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey.shade800,
              tabs: [
                GButton(
                  iconActiveColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryColor,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(.2),
                  icon: LineIcons.home,
                  text: 'Trang chủ',
                ),
                GButton(
                  iconActiveColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryColor,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(.2),
                  icon: LineIcons.map,
                  text: 'Bản đồ',
                ),
                GButton(
                  iconActiveColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryColor,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(.2),
                  icon: LineIcons.newspaper,
                  text: 'Tin tức',
                ),
                GButton(
                  iconActiveColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryColor,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(.2),
                  icon: LineIcons.history,
                  text: 'Báo cáo',
                )
              ],
              selectedIndex: indexPage,
              onTabChange: (index) {
                setState(() {
                  indexPage = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
