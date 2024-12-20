import 'package:flutter/material.dart';
import 'package:velocity_app/src/view/explore/community_tab.dart';
import 'package:velocity_app/src/view/explore/friends_tab.dart';
import 'package:velocity_app/src/view/explore/personal_tab.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Future<void> animateToTop(int index) async {
    final primaryController = PrimaryScrollController.of(context);
    await primaryController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Text(
                    'Velocity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  pinned: true,
                  // expandedHeight: 150.0,
                  // forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.explore),
                      ),
                      Tab(
                        icon: Icon(Icons.group),
                      ),
                      Tab(
                        icon: Icon(Icons.person),
                      ),
                    ],
                    labelColor: Colors.blue,
                    indicatorColor: Colors.blue,
                    onTap: (value) {
                      animateToTop(value);
                    },
                  ),
                  floating: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                ),
              ),
            ];
          },
          // note to future self: for some reason, without SafeArea, the padding of ONLY PersonalTab doesn't work
          body: const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: TabBarView(
                children: <Widget>[
                  CommunityTab(),
                  FriendsTab(),
                  PersonalTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
