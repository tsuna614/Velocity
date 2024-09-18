import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/view/home/detail_booking.dart';

class TravelCardWide extends StatefulWidget {
  const TravelCardWide({super.key, required this.data});

  final Travel data;

  @override
  State<TravelCardWide> createState() => _TravelCardWideState();
}

class _TravelCardWideState extends State<TravelCardWide> {
  final imageCardHeight = 200.0;
  late double travelCardHeight;

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
              Positioned(
                bottom: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.red,
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.data.title,
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

  Widget buildImageCard(BuildContext context, Travel travelData) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => onTravelCardPressed(context, travelData),
          child: Hero(
            tag: travelData.id,
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(travelData.imageUrl[0]),
              height: imageCardHeight,
              width: double.infinity,
              fit: BoxFit.cover,
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
