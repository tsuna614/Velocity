import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showBottomPanel = true;

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // User is scrolling down, hide the panel
      if (_showBottomPanel) {
        setState(() {
          _showBottomPanel = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // User is scrolling up, show the panel
      if (!_showBottomPanel) {
        setState(() {
          _showBottomPanel = true;
        });
      }
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

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
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.travelData.id,
                    child: FadeInImage(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(widget.travelData.imageUrl[0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  buildDescription(),
                  Divider(
                    color: Colors.black.withOpacity(0.1),
                    thickness: 2,
                  ),
                  buildDetailInformation(),
                  Divider(
                    color: Colors.black.withOpacity(0.1),
                    thickness: 2,
                  ),
                  buildDetailInformation(),
                  Divider(
                    color: Colors.black.withOpacity(0.1),
                    thickness: 2,
                  ),
                ],
              ),
            ),
            buildBookmarkButton(state),
            showBottomPanel(),
          ],
        ),
      );
    });
  }

  Widget showBottomPanel() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: _showBottomPanel ? 0 : -80, // Slide up and down
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
          color: Colors.white,
        ),
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${widget.travelData.price}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 60, 0),
                    ),
                  ),
                  const Text(
                    "All charges included",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Add to cart logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
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

  Widget buildBookmarkButton(UserLoaded state) {
    return SafeArea(
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
              state.user.bookmarkedTravels.contains(widget.travelData.id)
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              size: 30,
              color: state.user.bookmarkedTravels.contains(widget.travelData.id)
                  ? Colors.red
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}