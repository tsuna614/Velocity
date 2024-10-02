import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/book/book.events.dart';
import 'package:velocity_app/src/bloc/book/book.states.dart';
import 'package:velocity_app/src/bloc/book/book_bloc.dart';
import 'package:velocity_app/src/bloc/travel/travel_bloc.dart';
import 'package:velocity_app/src/bloc/travel/travel_states.dart';
import 'package:velocity_app/src/widgets/booking/travel_booking_receipt.dart';

enum ReceiptStatus {
  active,
  past,
}

class ReceiptPage extends StatelessWidget {
  final ReceiptStatus status;
  const ReceiptPage({super.key, required this.status});

  Future<void> _handleRefresh(BuildContext context) async {
    BlocProvider.of<BookBloc>(context).add(FetchBooks());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(builder: (context, bookingState) {
      if (bookingState is! BookLoaded) {
        return ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return const TravelBookingReceiptSkeleton();
            });
      }

      if (bookingState.books.isEmpty) {
        return const Center(
          child: Text(
            "You don't have any active bookings",
          ),
        );
      }

      return BlocBuilder<TravelBloc, TravelState>(
          builder: (context, travelState) {
        if (travelState is! TravelLoaded) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // sorted bookings based on whether the date is in the past or future
        final sortedBookings = bookingState.books.where((e) {
          if (status == ReceiptStatus.active) {
            return e.dateOfTravel.isAfter(DateTime.now());
          } else {
            return e.dateOfTravel.isBefore(DateTime.now());
          }
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () => _handleRefresh(context),
            child: ListView.builder(
              itemCount: sortedBookings.length,
              itemBuilder: (context, index) {
                final travelData = travelState.travels
                    .firstWhere((e) => e.id == sortedBookings[index].travelId);

                return TravelBookingReceipt(
                  travelData: travelData,
                  bookData: sortedBookings[index],
                  status: status,
                );
              },
            ),
          ),
        );
      });
    });
  }
}
