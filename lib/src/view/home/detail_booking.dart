import 'package:flutter/material.dart';
import 'package:velocity_app/src/model/tour_model.dart';

class DetailBooking extends StatefulWidget {
  const DetailBooking({super.key, required this.travelData});

  final Travel travelData;

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

class _DetailBookingState extends State<DetailBooking> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
