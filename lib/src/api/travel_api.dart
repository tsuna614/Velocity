import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/travel/travel_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/widgets/tour_card.dart';

class TravelApi {}

class GeneralApi {
  List<Travel> getTravelDataOfType(
      {required BuildContext context, required TravelType dataType}) {
    switch (dataType) {
      case TravelType.tour:
        return BlocProvider.of<TravelBloc>(context).state.tours;
      case TravelType.hotel:
        return BlocProvider.of<TravelBloc>(context).state.hotels;
      case TravelType.flight:
        return BlocProvider.of<TravelBloc>(context).state.flights;
      case TravelType.car:
        return BlocProvider.of<TravelBloc>(context).state.carRentals;
      default:
        return [];
    }
  }

  List<Travel> getAllTraveldata({required BuildContext context}) {
    final travelBloc = BlocProvider.of<TravelBloc>(context);
    return [
      ...travelBloc.state.tours,
      ...travelBloc.state.hotels,
      ...travelBloc.state.flights,
      ...travelBloc.state.carRentals,
    ];
  }

  void toggleBookmark(
      {required BuildContext context, required String travelId}) {
    final userData = BlocProvider.of<UserBloc>(context).state as UserLoaded;
    if (userData.user.bookmarkedTravels.contains(travelId)) {
      BlocProvider.of<UserBloc>(context)
          .add(RemoveBookmark(travelId: travelId));

      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bookmark removed'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      BlocProvider.of<UserBloc>(context).add(AddBookmark(travelId: travelId));

      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bookmark added'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
