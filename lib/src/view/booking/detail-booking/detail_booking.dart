import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/view/booking/detail-booking/rating_page.dart';
import 'package:velocity_app/src/view/booking/payment-flow/booking_screen.dart';
import 'package:velocity_app/src/widgets/booking/amount_picker.dart';
import 'package:velocity_app/src/widgets/booking/custom_date_picker.dart';

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

  Color _appBarColor = Colors.transparent;

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
    // Change the app bar color when user scrolls
    if (_scrollController.offset > 50) {
      setState(() {
        _appBarColor = Colors.blue; // Change to your preferred color
      });
    } else {
      setState(() {
        _appBarColor = Colors.transparent;
      });
    }
  }

  void _pushBookingScreen(BuildContext context) {
    if (_amountCounter == 0) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          travelData: widget.travelData,
          amount: _amountCounter,
          dateOfTravel: _selectedDate,
        ),
      ),
    );
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
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: _appBarColor,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () {
                    BlocProvider.of<UserBloc>(context).add(
                      ToggleBookmark(
                        travelId: widget.travelData.id,
                        context: context,
                      ),
                    );
                  },
                  icon: Icon(
                    state.user.bookmarkedTravels.contains(widget.travelData.id)
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: state.user.bookmarkedTravels
                            .contains(widget.travelData.id)
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
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
                onPressed: _amountCounter == 0
                    ? null
                    : () {
                        _pushBookingScreen(context);
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
          buildOverviewNode(FontAwesomeIcons.solidStar, "Rating",
              "${widget.travelData.rating.toStringAsFixed(1)}/5.0"),
        ],
      ),
    );
  }

  Widget buildOverviewNode(IconData icon, String title, String value) {
    return InkWell(
      onTap: () {
        if (title == "Rating") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RatingPage(
                travelData: widget.travelData,
              ),
            ),
          );
        }
      },
      child: Padding(
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
      ),
    );
  }
}
