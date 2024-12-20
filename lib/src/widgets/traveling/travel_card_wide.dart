import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/view/booking/detail-booking/detail_booking_screen.dart';

class TravelCardWide extends StatefulWidget {
  const TravelCardWide({super.key, required this.data});

  final TravelModel data;

  @override
  State<TravelCardWide> createState() => _TravelCardWideState();
}

class _TravelCardWideState extends State<TravelCardWide> {
  final imageCardHeight = 200.0;
  late double travelCardHeight;

  void onTravelCardPressed(BuildContext context, TravelModel travelData) {
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
      travelCardHeight == imageCardHeight
          ? travelCardHeight = imageCardHeight + 50
          : travelCardHeight = imageCardHeight;
    });
  }

  @override
  void initState() {
    travelCardHeight = imageCardHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: travelCardHeight,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge, // Clip the image
                child: buildImageCard(context, widget.data),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildImageCard(BuildContext context, TravelModel travelData) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => onTravelCardPressed(context, travelData),
          child: Hero(
            tag: travelData.id,
            child: Stack(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: imageCardHeight,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                ),
                FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(travelData.imageUrl[0]),
                  height: imageCardHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/image-error.png",
                      height: imageCardHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ],
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
