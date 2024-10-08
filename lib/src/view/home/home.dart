import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/src/bloc/travel/travel_bloc.dart';
import 'package:velocity_app/src/bloc/travel/travel_events.dart';
import 'package:velocity_app/src/bloc/travel/travel_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/widgets/traveling/home_travel_banner_buttons.dart';
import 'package:velocity_app/src/widgets/search_bar.dart';
import 'package:velocity_app/src/widgets/traveling/travel_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TourPage(),
      ),
    );
  }
}

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  State<TourPage> createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  final double bannerHeight = 60;
  final double bannerSelectionCardHeight = 80;

  final _scrollController = ScrollController();

  final List<String> titleList = [
    "Tours",
    "Hotels",
    "Flights",
    "Car Rentals",
  ];

  final List<IconData> iconList = [
    FontAwesomeIcons.mapLocationDot,
    FontAwesomeIcons.hotel,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.car,
  ];

  final List<String> sortOptions = [
    'Price',
    'Rating',
    'Duration',
    'Popularity',
    'Newest',
  ];

  final List<TravelType> travelTypeList = [
    TravelType.tour,
    TravelType.hotel,
    TravelType.flight,
    TravelType.car,
  ];

  final List<GlobalKey> keyList = List.generate(4, (index) => GlobalKey());

  void _scrollToPosition(int index) {
    final widgetHeight = keyList[index].currentContext!.size!.height;

    _scrollController.animateTo(
      widgetHeight * index.toDouble(),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelBloc, TravelState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const MySearchBar(),
          backgroundColor: Colors.blue,
          scrolledUnderElevation: 0,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<TravelBloc>(context).add(LoadData());
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                      top: bannerHeight + bannerSelectionCardHeight / 2 + 10),
                  child: Column(
                    children: List.generate(titleList.length, (index) {
                      List<Travel> travelData = [];

                      if (state is TravelLoaded) {
                        switch (titleList[index]) {
                          case "Tours":
                            travelData =
                                state.travels.whereType<Tour>().toList();
                            break;
                          case "Hotels":
                            travelData =
                                state.travels.whereType<Hotel>().toList();
                            break;
                          case "Flights":
                            travelData =
                                state.travels.whereType<Flight>().toList();
                            break;
                          case "Car Rentals":
                            travelData =
                                state.travels.whereType<CarRental>().toList();
                            break;
                          default:
                        }
                      }

                      return Column(
                        key: keyList[index],
                        children: [
                          buildTitle(
                            title: titleList[index],
                            icon: iconList[index],
                          ),
                          state is TravelLoaded
                              ? TravelCard(
                                  sortOptions: sortOptions,
                                  travelData: travelData,
                                )
                              : const TravelCardSkeleton(),
                          const Divider(),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            buildBanner(),
          ],
        ),
      );
    });
  }

  Widget buildTitle({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 2, color: Colors.blue),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            // AppLocalizations.of(context)!.helloWorld,
            title,
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget buildBanner() {
    return SizedBox(
      height: bannerHeight + bannerSelectionCardHeight / 2,
      child: Stack(
        children: [
          Container(
            height: bannerHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge,
              elevation: 2,
              child: Container(
                height: bannerSelectionCardHeight,
                width: MediaQuery.of(context).size.width * 0.9,
                color: Colors.white,
                child: HomeTravelBannerButtons(
                  onPressed: (index) {
                    _scrollToPosition(index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
