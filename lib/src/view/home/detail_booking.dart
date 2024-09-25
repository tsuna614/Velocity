import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:velocity_app/src/api/travel_api.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/widgets/traveling/amount_picker.dart';
import 'package:velocity_app/src/widgets/traveling/custom_date_picker.dart';

class DetailBooking extends StatefulWidget {
  const DetailBooking({super.key, required this.travelData});

  final Travel travelData;

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

class _DetailBookingState extends State<DetailBooking> {
  final ScrollController _scrollController = ScrollController();
  bool _showBottomPanel = true;
  final double _bottomPanelHeight = 80;

  int _amountCounter = 0;
  DateTime _selectedDate = DateTime.now();

  void onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void onAmountSelected(int amount) {
    setState(() {
      _amountCounter = amount;
    });
  }

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

    // If user scrolls to the bottom of the screen, show the panel
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
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
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: _bottomPanelHeight + 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDetailedImage(state),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: CustomDatePicker(
                              onDateSelected: onDateSelected,
                              selectedDate: _selectedDate,
                            ),
                          ),
                          Divider(
                            color: Colors.black.withOpacity(0.1),
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: AmountPicker(
                                money: widget.travelData.price,
                                description: "per ticket",
                                onAmountSelected: onAmountSelected,
                                amount: _amountCounter),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // the reason I wrap the stack with (expanded wrapped with column)
                  // is for this panel to appear at the bottom of the screen
                  showBottomPanel(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildDetailedImage(UserLoaded state) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: [
          Hero(
            tag: widget.travelData.id,
            child: FadeInImage(
              height: double.infinity,
              width: double.infinity,
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(widget.travelData.imageUrl[0]),
              fit: BoxFit.cover,
            ),
          ),
          buildTopButtons(state),
        ],
      ),
    );
  }

  Widget showBottomPanel() {
    return AnimatedPositioned(
      left: 0,
      right: 0,
      bottom: _showBottomPanel ? 0 : -80, // Slide up and down
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
        height: _bottomPanelHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${(_amountCounter * widget.travelData.price).toStringAsFixed(2)}",
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Overview",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (widget.travelData is Tour)
            Column(
              children: [
                buildOverviewNode(
                  FontAwesomeIcons.locationDot,
                  "Destination",
                  (widget.travelData as Tour).destination,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.clock,
                  "Duration",
                  (widget.travelData as Tour).duration,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.building,
                  "City",
                  (widget.travelData as Tour).city,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.users,
                  "Capacity",
                  (widget.travelData as Tour).capacity.toString(),
                ),
              ],
            ),
          if (widget.travelData is Hotel)
            Column(
              children: [
                buildOverviewNode(
                  FontAwesomeIcons.building,
                  "Address",
                  (widget.travelData as Hotel).address,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.phone,
                  "Contact",
                  (widget.travelData as Hotel).contact,
                ),
              ],
            ),
          if (widget.travelData is Flight)
            Column(
              children: [
                buildOverviewNode(
                  FontAwesomeIcons.planeDeparture,
                  "Origin",
                  (widget.travelData as Flight).origin,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.planeArrival,
                  "Destination",
                  (widget.travelData as Flight).destination,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.clock,
                  "Departure Time",
                  (widget.travelData as Flight).departureTime,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.clock,
                  "Arrival Time",
                  (widget.travelData as Flight).arrivalTime,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.plane,
                  "Airline",
                  (widget.travelData as Flight).airline,
                ),
              ],
            ),
          if (widget.travelData is CarRental)
            Column(
              children: [
                buildOverviewNode(
                  FontAwesomeIcons.locationDot,
                  "Location",
                  (widget.travelData as CarRental).location,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.phone,
                  "Contact",
                  (widget.travelData as CarRental).contact,
                ),
                buildOverviewNode(
                  FontAwesomeIcons.car,
                  "Car Type",
                  (widget.travelData as CarRental).carType,
                ),
              ],
            ),
          buildOverviewNode(FontAwesomeIcons.dollarSign, "Price",
              "\$${widget.travelData.price}"),
          buildOverviewNode(FontAwesomeIcons.solidStar, "Rating", "5.0/5.0"),
        ],
      ),
    );
  }

  Widget buildOverviewNode(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 104, 104, 104),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopButtons(UserLoaded state) {
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
          Hero(
            tag: "${widget.travelData.id}-bookmark",
            child: IconButton(
              onPressed: () {
                GeneralApi().toggleBookmark(
                    context: context, travelId: widget.travelData.id);
              },
              icon: Icon(
                state.user.bookmarkedTravels.contains(widget.travelData.id)
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                size: 30,
                color:
                    state.user.bookmarkedTravels.contains(widget.travelData.id)
                        ? Colors.red
                        : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
