import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/api/travel_api.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/widgets/traveling/travel_card_wide.dart';

// NOTE TO SELF: The bookmarked travel's id is stored in the user's bookmarkedTravels list.
// The TravelCardWide widget display all travel datas that are passed into it
// Because of this, the data will be displayed in the order that the data are get in GeneralApi().getAllTraveldata
// (which is tour -> hotel -> flight -> carRental)
// If I want to display it in a order from newest to oldest (or vice versa)
// make the TravelCardWide accept travel's id instead and build while running through user's bookmarkedTravels list

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final travelDatas = GeneralApi()
        .getAllTraveldata(context: context)
        .where((e) => (BlocProvider.of<UserBloc>(context).state as UserLoaded)
            .user
            .bookmarkedTravels
            .contains(e.id))
        .toList();

    return Scaffold(
      body: travelDatas.isEmpty
          ? const Center(child: Text("No bookmark found"))
          : ListView.builder(
              itemCount: travelDatas.length,
              itemBuilder: (context, index) {
                return TravelCardWide(data: travelDatas[index]);
              },
            ),
    );
  }
}
