import 'package:flutter/material.dart';
import 'package:velocity_app/src/view/explore/community_tab.dart';
import 'package:velocity_app/src/view/explore/personal_tab.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      const CommunityTab(),
      const PersonalTab(),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: const SliverAppBar(
                  title: Text(
                    'Velocity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  pinned: true,
                  // expandedHeight: 150.0,
                  // forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.group),
                      ),
                      Tab(
                        icon: Icon(Icons.person),
                      ),
                    ],
                    labelColor: Colors.blue,
                    indicatorColor: Colors.blue,
                  ),
                  floating: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: TabBarView(
              children: tabs,
            ),
          ),
        ),
      ),
    );
  }
}
