import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import '../../data/dummy_data.dart' as dummy_data;

///////////// Dummy Data /////////////

///////////// Travel Bloc /////////////
class TravelState {
  final List<Tour> tours;
  final List<Hotel> hotels;
  final List<Flight> flights;
  final List<CarRental> carRentals;

  TravelState(
      {this.tours = const [],
      this.hotels = const [],
      this.flights = const [],
      this.carRentals = const []});

  TravelState copyWith({
    List<Tour>? tours,
    List<Hotel>? hotels,
    List<Flight>? flights,
    List<CarRental>? carRentals,
  }) {
    return TravelState(
      tours: tours ?? this.tours,
      hotels: hotels ?? this.hotels,
      flights: flights ?? this.flights,
      carRentals: carRentals ?? this.carRentals,
    );
  }
}

abstract class TravelEvent {}

class LoadData extends TravelEvent {}

class UpdateTour extends TravelEvent {
  final Tour tour;

  UpdateTour(this.tour);
}

class UpdateHotel extends TravelEvent {
  final Hotel hotel;

  UpdateHotel(this.hotel);
}

class UpdateFlight extends TravelEvent {
  final Flight flight;

  UpdateFlight(this.flight);
}

class UpdateCarRental extends TravelEvent {
  final CarRental carRental;

  UpdateCarRental(this.carRental);
}

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  TravelBloc() : super(TravelState(tours: [])) {
    on<LoadData>((event, emit) {
      emit(TravelState(
        tours: dummy_data.tours,
        hotels: dummy_data.hotels,
        flights: dummy_data.flights,
        carRentals: dummy_data.carRentals,
      ));
    });

    on<UpdateTour>((event, emit) {
      final updatedTours = state.tours.map((tour) {
        if (tour.title == event.tour.title) {
          return event.tour;
        }
        return tour;
      }).toList();
      emit(state.copyWith(tours: updatedTours));
    });

    on<UpdateHotel>((event, emit) {
      final updatedHotels = state.hotels.map((hotel) {
        if (hotel.title == event.hotel.title) {
          return event.hotel;
        }
        return hotel;
      }).toList();
      emit(state.copyWith(hotels: updatedHotels));
    });

    on<UpdateFlight>((event, emit) {
      final updatedFlights = state.flights.map((flight) {
        if (flight.title == event.flight.title) {
          return event.flight;
        }
        return flight;
      }).toList();
      emit(state.copyWith(flights: updatedFlights));
    });

    on<UpdateCarRental>((event, emit) {
      final updatedCarRentals = state.carRentals.map((carRental) {
        if (carRental.title == event.carRental.title) {
          return event.carRental;
        }
        return carRental;
      }).toList();
      emit(state.copyWith(carRentals: updatedCarRentals));
    });
  }
}
