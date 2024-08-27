import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/src/api/travel_api.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/view/booking/detail_booking.dart';

class TravelCardWide extends StatefulWidget {
  const TravelCardWide({super.key});

  @override
  State<TravelCardWide> createState() => _TravelCardWideState();
}

class _TravelCardWideState extends State<TravelCardWide> {
  final imageCardHeight = 200.0;
  double travelCardHeight = 200.0;

  void onTravelCardPressed(BuildContext context, Travel travelData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DetailBooking(travelData: travelData);
        },
      ),
    );
  }

  void extendTravelCard() {
    setState(() {
      travelCardHeight == 200.0
          ? travelCardHeight = 300.0
          : travelCardHeight = 200.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final travelDatas = GeneralApi()
        .getAllTraveldata(context: context)
        .where((e) => (BlocProvider.of<UserBloc>(context).state as UserLoaded)
            .user
            .bookmarkedTravels
            .contains(e.id))
        .toList();

    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      return ListView.builder(
        itemCount: travelDatas.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              height: travelCardHeight,
              child: Card(
                elevation: 10,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Column(
                          children: [
                            Text(
                              travelDatas[index].title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.hardEdge, // Clip the image
                      child: buildImageCard(
                          context, travelDatas[index], state as UserLoaded),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildImageCard(
      BuildContext context, Travel travelData, UserLoaded state) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => onTravelCardPressed(context, travelData),
          child: Image.network(
            travelData.imageUrl[0],
            height: imageCardHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () => GeneralApi()
                .toggleBookmark(context: context, travelId: travelData.id),
            child: Icon(
              state.user.bookmarkedTravels.contains(travelData.id)
                  ? FontAwesomeIcons.solidBookmark
                  : FontAwesomeIcons.bookmark,
              color: state.user.bookmarkedTravels.contains(travelData.id)
                  ? Colors.red
                  : Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: extendTravelCard,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  travelData.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
