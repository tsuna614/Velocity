import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/services/travel_api.dart';
import 'package:velocity_app/src/bloc/travel/travel_events.dart';
import 'package:velocity_app/src/bloc/travel/travel_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';

///////////// Dummy Data /////////////

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  final TravelApi travelApi;

  TravelBloc(this.travelApi) : super(TravelInitial()) {
    on<LoadData>((event, emit) async {
      emit(TravelLoading());
      final List<Travel> travels = await travelApi.fetchTravelData();
      emit(TravelLoaded(
        travels: travels,
      ));
    });

    // on<UpdateTour>((event, emit) {
    //   if (state is TravelLoaded) {
    //     final updatedTours = (state as TravelLoaded).tours.map((tour) {
    //       if (tour.title == event.tour.title) {
    //         return event.tour;
    //       }
    //       return tour;
    //     }).toList();
    //     emit((state as TravelLoaded).copyWith(tours: updatedTours));
    //   }
    // });

    // on<UpdateHotel>((event, emit) {
    //   if (state is TravelLoaded) {
    //     final updatedHotels = (state as TravelLoaded).hotels.map((hotel) {
    //       if (hotel.title == event.hotel.title) {
    //         return event.hotel;
    //       }
    //       return hotel;
    //     }).toList();
    //     emit((state as TravelLoaded).copyWith(hotels: updatedHotels));
    //   }
    // });

    // on<UpdateFlight>((event, emit) {
    //   if (state is TravelLoaded) {
    //     final updatedFlights = (state as TravelLoaded).flights.map((flight) {
    //       if (flight.title == event.flight.title) {
    //         return event.flight;
    //       }
    //       return flight;
    //     }).toList();
    //     emit((state as TravelLoaded).copyWith(flights: updatedFlights));
    //   }
    // });

    // on<UpdateCarRental>((event, emit) {
    //   if (state is TravelLoaded) {
    //     final updatedCarRentals =
    //         (state as TravelLoaded).carRentals.map((carRental) {
    //       if (carRental.title == event.carRental.title) {
    //         return event.carRental;
    //       }
    //       return carRental;
    //     }).toList();
    //     emit((state as TravelLoaded).copyWith(carRentals: updatedCarRentals));
    //   }
    // });
  }
}
