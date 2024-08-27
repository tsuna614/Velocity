import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:velocity_app/src/api/travel_api.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/view/booking/detail_booking.dart';

enum TravelType {
  tour,
  hotel,
  flight,
  car,
}

class TourCard extends StatelessWidget {
  const TourCard({super.key, required this.dataType});

  final TravelType dataType;

  void onBookmarkTap(BuildContext context, String id) {
    GeneralApi().toggleBookmark(context: context, travelId: id);
  }

  @override
  Widget build(BuildContext context) {
    final travelData =
        GeneralApi().getTravelDataOfType(context: context, dataType: dataType);

    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      final userData = state as UserLoaded;

      return SizedBox(
        height: 350,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: travelData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.hardEdge,
                elevation: 2,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DetailBooking(
                                  travelData: travelData[index]);
                            },
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          FadeInImage(
                            height: 200,
                            width: 200,
                            placeholder: MemoryImage(kTransparentImage),
                            image: NetworkImage(travelData[index].imageUrl[0]),
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 5),
                          Flexible(
                            child: Container(
                              width: 200,
                              child:
                                  buildTourDetails(context, travelData, index),
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildBookmarkButton(context, travelData, userData, index),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildTourDetails(
      BuildContext context, List<Travel> travelData, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            overflow: TextOverflow.ellipsis,
            travelData[index].title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            travelData[index] is Tour
                ? (travelData[index] as Tour).duration
                : "null",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 104, 104, 104),
            ),
          ),
          Text(
            "\$${travelData[index].price}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < 5; i++)
                  travelData[index].rating - i <= 0
                      ? const Icon(
                          Icons.star_border,
                          color: Colors.orange,
                        )
                      : travelData[index].rating - i < 1
                          ? const Icon(
                              Icons.star_half,
                              color: Colors.orange,
                            )
                          : const Icon(
                              Icons.star,
                              color: Colors.orange,
                            )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookmarkButton(BuildContext context, List<Travel> travelData,
      UserLoaded userData, int index) {
    return Positioned(
      top: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {
              onBookmarkTap(context, travelData[index].id);
            },
            child: Icon(
              userData.user.bookmarkedTravels.contains(travelData[index].id)
                  ? FontAwesomeIcons.solidBookmark
                  : FontAwesomeIcons.bookmark,
              color:
                  userData.user.bookmarkedTravels.contains(travelData[index].id)
                      ? Colors.red
                      : Colors.white,
            )),
      ),
    );
  }
}
