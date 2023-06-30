import 'package:flutter/material.dart';

import 'iqair/iqair_screen.dart';
import 'mxh/news_fb_screen.dart';
import 'web/news_web_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() {
    return _NewsScreenState();
  }
}

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final bool _showBackToTopButton = false;

  @override
  void initState() {
    // _scrollController.addListener(() {
    //   //scroll listener
    //   double showoffset =
    //       10.0; //Back to top botton will show on scroll offset 10.0

    //   if (_scrollController.offset > showoffset) {
    //     setState(() {
    //       _showBackToTopButton = true;
    //     });
    //   } else {
    //     setState(() {
    //       _showBackToTopButton = false;
    //     });
    //   }
    // });
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), //duration of scroll
        curve: Curves.fastOutSlowIn //scroll type
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 500), //show/hide animation
        opacity: _showBackToTopButton
            ? 1.0
            : 0.0, //set obacity to 1 on visible, or hide
        child: _showBackToTopButton
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward),
              )
            : null,
      ),
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text('Tin tức'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              elevation: 0,
              backgroundColor:
                  Theme.of(context).appBarTheme.backgroundColor?.withOpacity(1),
              bottom: TabBar(
                tabs: const <Tab>[
                  Tab(
                    icon: Icon(Icons.newspaper_rounded),
                    text: "Bài báo",
                  ),
                  Tab(
                    icon: Icon(Icons.facebook_rounded),
                    text: "Mạng xã hội",
                  ),
                  Tab(
                    icon: Icon(Icons.stacked_line_chart_rounded),
                    text: "Xếp hạng",
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            NewsWebScreen(),
            NewsFBScreen(),
            IQAirScreen(),
          ],
        ),
      ),
    );
  }
}
