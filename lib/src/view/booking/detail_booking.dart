import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:velocity_app/src/api/travel_api.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';

class DetailBooking extends StatefulWidget {
  const DetailBooking({super.key, required this.travelData});

  final Travel travelData;

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

class _DetailBookingState extends State<DetailBooking> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is! UserLoaded) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInImage(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(widget.travelData.imageUrl[0]),
                    fit: BoxFit.cover,
                  ),
                  buildDescription(),
                  Divider(
                    color: Colors.black.withOpacity(0.1),
                    thickness: 4,
                  ),
                  buildDetailInformation(),
                  Divider(
                    color: Colors.black.withOpacity(0.1),
                    thickness: 4,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      GeneralApi().toggleBookmark(
                          context: context, travelId: widget.travelData.id);
                    },
                    icon: Icon(
                      state.user.bookmarkedTravels
                              .contains(widget.travelData.id)
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      size: 30,
                      color: state.user.bookmarkedTravels
                              .contains(widget.travelData.id)
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          const Text("Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            widget.travelData.description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildDetailInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          const Text("Overview",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          buildOverviewNode(
              FontAwesomeIcons.locationDot,
              "Destination",
              widget.travelData is Tour
                  ? (widget.travelData as Tour).city
                  : "null"),
          const SizedBox(height: 10),
          buildOverviewNode(
              FontAwesomeIcons.clock,
              "Duration",
              widget.travelData is Tour
                  ? (widget.travelData as Tour).duration
                  : "null"),
          const SizedBox(height: 10),
          buildOverviewNode(FontAwesomeIcons.dollarSign, "Price",
              "\$${widget.travelData.price}"),
          const SizedBox(height: 10),
          buildOverviewNode(FontAwesomeIcons.solidStar, "Rating",
              "${widget.travelData.rating}/5.0"),
        ],
      ),
    );
  }

  Widget buildOverviewNode(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 104, 104, 104),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
