import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/src/bloc/tour_bloc.dart';
import 'package:velocity_app/src/widgets/home_travel_banner_buttons.dart';
import 'package:velocity_app/src/widgets/search_bar.dart';
import 'package:velocity_app/src/widgets/sort_button_horizontal_list.dart';
import 'package:velocity_app/src/widgets/tour_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final travelBloc = TravelBloc();

        travelBloc.add(LoadData());

        return travelBloc;
      },
      child: const Scaffold(
        body: Center(
          child: TourPage(),
        ),
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
  double bannerHeight = 60;
  double bannerSelectionCardHeight = 80;

  final List<String> sortOptions = [
    'Price',
    'Rating',
    'Duration',
    'Popularity',
  ];

  void handlePress(BuildContext context) {
    print(BlocProvider.of<TravelBloc>(context).state.tours[0].title);
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
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  buildTitle(
                      title: "Tours", icon: FontAwesomeIcons.mapLocationDot),
                  SizedBox(
                    height: 50,
                    child: SortButtonHorizontalList(sortOptions: sortOptions),
                  ),
                  TourCard(travelData: state.tours),
                  const Divider(),
                  buildTitle(title: "Hotels", icon: FontAwesomeIcons.hotel),
                  SizedBox(
                    height: 50,
                    child: SortButtonHorizontalList(sortOptions: sortOptions),
                  ),
                  TourCard(travelData: state.hotels),
                ],
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
                child: HomeTravelBannerButtons(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
